#!/usr/bin/perl

use Term::ANSIColor;
use Getopt::Long;

sub user {
    $u = `whoami`;
    chomp $u;
    return $u;
}

sub host {
    $h = `hostname`;
    chomp $h;
    return $h;
}

sub get_os {
    my $os = `lsb_release -sd`;
    for($os){
        s/"//;
        s/ .*//;
        chomp;
    }
    return $os;
}

sub get_de {
    return $ENV{XDG_SESSION_DESKTOP};
}

sub shell {
    return (split '/', $ENV{SHELL})[-1];
}

sub kernel {
    my $ke = `uname -r`;
    $ke =~ s/-.*//;
    chomp $ke;
    return $ke
}

sub packages {
    # for arch based
    my $pacs = `pacman -Q`;
    # for debian based
    unless($pacs) {
        $pacs = `apt list --installed`;
    }
    # for fedora
    unless($pacs) {
        $pacs = `yum list installed`;
    }
    my $count = 0;
    foreach my $p (split '\n', $pacs) {
        $count++;
    }
    return $count;
}

sub uptime {
    my $time = `uptime -p`;
    for($time) {
        s/up //;
        s/.day./d/;
        s/.hour./h/;
        s/.minute./m/;
        chomp;
    }
    return $time;
}

sub get_info {
    my $os = get_os();
    my $ke = kernel();
    my $de = get_de();
    my $sh = shell();
    my $upt = uptime();
    my $pac = packages();
    my $help;

    GetOptions (
        "help" => \$help,
        "os=s" => \$os,
        "kernel=s" => \$ke,
        "de=s" => \$de,
        "shell=s" => \$sh,
        "uptime=s" => \$upt,
        "packages=i" => \$pac,
    );

    if($help) {
        print_help();
    }

    my $width = 25 - 12;

    # format os => "OS        EndeavourOS  "
    $os = green('OS' . ' ' x 8) . $os . ' ' x ($width - length $os);

    # format kernel => "KERNEL        5.11.9        "
    $ke = blue('KERNEL' . ' ' x 4) . $ke . ' ' x ($width - length $ke);

    # format de => "DE        awesome        "
    $de = yellow('DE' . ' ' x 8) . $de . ' ' x ($width - length $de);

    # format shell => "SHELL     fish        "
    $sh = green('SHELL' . ' ' x 5) . $sh . ' ' x ($width - length $sh);

    # format uptime => "UPTIME   17h, 29m      "
    $upt = magenta('UPTIME' . ' ' x 4) . $upt . ' ' x ($width - length $upt);

    # format packages => "PACKAGE   314         "
    $pac = blue('PACKAGE' . ' ' x 3) . $pac . ' ' x ($width - length $pac);

    my $i = 0;
    $info[$i++] = ' ' x ($width + 10);
    $info[$i++] = $os;
    $info[$i++] = $ke;
    $info[$i++] = $de;
    $info[$i++] = $sh;
    $info[$i++] = $upt;
    $info[$i++] = $pac;
    $info[$i++] = ' ' x ($width + 10);

    return $info;
}

sub red {
    my ($text) = @_;
    return colored($text, 'red');
}

sub blue {
    my ($text) = @_;
    return colored($text, 'blue');
}

sub green {
    my ($text) = @_;
    return colored($text, 'green');
}

sub yellow {
    my ($text) = @_;
    return colored($text, 'yellow');
}

sub magenta {
    my ($text) = @_;
    return colored($text, 'magenta');
}

sub cyan {
    my ($text) = @_;
    return colored($text, 'cyan');
}

sub orange {
    my ($text) = @_;
    return colored($text, 'bold yellow');
}

sub dilbert {
    my $info = get_info();

    my $text = "\n";
    $text .= yellow('              ╭─────────────────────────╮') . "\n";
    $text .= yellow('    დოოოოოდ   │  ') . $info[0] . yellow('│') . "\n";
    $text .= yellow('    |     |   │  ') . $info[1] . yellow('│') . "\n";
    $text .= yellow('    |     |  ╭│  ') . $info[2] . yellow('│') . "\n";
    $text .= yellow('    |-ᱛ ᱛ-|  ││  ') . $info[3] . yellow('│') . "\n";
    $text .= yellow('   Ͼ   ∪   Ͽ ││  ') . $info[4] . yellow('│') . "\n";
    $text .= yellow('    |     |  ╯│  ') . $info[5] . yellow('│') . "\n";
    $text .= yellow('   ˏ`-.ŏ.-´ˎ  │  ') . $info[6] . yellow('│') . "\n";
    $text .= yellow('       @      │  ') . $info[7] . yellow('│') . "\n";
    $text .= yellow('        @     ╰─────────────────────────╯') . "\n";
    $text .= "\n";

    print $text;
}

sub print_help {

    print "usage: fm6000 [options]\n\n";
    print "-o, --os=STR    OS name\n\n";
    print "-k or --kernel=STR    Kernel version\n\n";
    print "-d or --de=STR    Desktop environment name\n\n";
    print "-s or --shell=STR    Shell name\n\n";
    print "-u or --uptime=STR    Uptime\n\n";
    print "-p or --package=INT    Number of packages\n\n";

    exit;
}

dilbert();

