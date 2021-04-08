#!/usr/bin/perl

use Term::ANSIColor;
use Getopt::Long;

my $width = 25 - 12;
my $gap = 10;
my $margin = 2;
my $color = 'yellow';

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

sub format_info {
    # format de => "DE        awesome        "
    # format kernel => "KERNEL        5.11.9        "
    # format os => "OS        EndeavourOS  "
    # format packages => "PACKAGE   314         "
    # format shell => "SHELL     fish        "
    # format uptime => "UPTIME   17h, 29m      "
    my %info = %{(shift)};
    my $text = ' ' x $margin . colored($info{'placeholder'}, $info{'color'});
    $text .= ' ' x ($gap - length $info{'placeholder'});
    $text .= $info{'name'} . ' ' x ($width - length $info{'name'});

    return $text;
}

sub get_info {
    my $os = get_os();
    my $ke = kernel();
    my $de = get_de();
    my $sh = shell();
    my $up = uptime();
    my $pac = packages();
    my $help;

    GetOptions (
        "help" => \$help,
        "os=s" => \$os,
        "kernel=s" => \$ke,
        "de=s" => \$de,
        "shell=s" => \$sh,
        "uptime=s" => \$up,
        "packages=i" => \$pac,
        "margin=i" => \$margin,
        "width=i" => \$width,
        "gap=i" => \$gap,
        "color=s" => \$color,
    );

    if($help) {
        print_help();
    }

    %os = (
        'placeholder' => 'OS',
        'color' => 'green',
        'name' => $os,
    );

    %ke = (
        'placeholder' => 'KERNEL',
        'color' => 'blue',
        'name' => $ke,
    );

    %de = (
        'placeholder' => 'OS',
        'color' => 'yellow',
        'name' => $de,
    );

    %sh = (
        'placeholder' => 'SHELL',
        'color' => 'green',
        'name' => $sh,
    );

    %up = (
        'placeholder' => 'UPTIME',
        'color' => 'magenta',
        'name' => $up,
    );

    %pac = (
        'placeholder' => 'PACKAGE',
        'color' => 'blue',
        'name' => $pac,
    );

    $os = format_info(\%os);
    $ke = format_info(\%ke);
    $de = format_info(\%de);
    $sh = format_info(\%sh);
    $up = format_info(\%up);
    $pac = format_info(\%pac);

    my $i = 0;
    $info[$i++] = ' ' x ($width + $gap + $margin);
    $info[$i++] = $os;
    $info[$i++] = $ke;
    $info[$i++] = $de;
    $info[$i++] = $sh;
    $info[$i++] = $up;
    $info[$i++] = $pac;
    $info[$i++] = ' ' x ($width + $gap + $margin);

    return $info;
}

sub dilbert {
    my $info = get_info();

    my $text = "\n";
    $text .= colored('              ╭' . '─' x ($width + $margin + $gap) . '╮', $color) . "\n";
    $text .= colored('    დოოოოოდ   │', $color) . $info[0] . colored('│', $color) . "\n";
    $text .= colored('    |     |   │', $color) . $info[1] . colored('│', $color) . "\n";
    $text .= colored('    |     |  ╭│', $color) . $info[2] . colored('│', $color) . "\n";
    $text .= colored('    |-ᱛ ᱛ-|  ││', $color) . $info[3] . colored('│', $color) . "\n";
    $text .= colored('   Ͼ   ∪   Ͽ ││', $color) . $info[4] . colored('│', $color) . "\n";
    $text .= colored('    |     |  ╯│', $color) . $info[5] . colored('│', $color) . "\n";
    $text .= colored('   ˏ`-.ŏ.-´ˎ  │', $color) . $info[6] . colored('│', $color) . "\n";
    $text .= colored('       @      │', $color) . $info[7] . colored('│', $color) . "\n";
    $text .= colored('        @     ╰' . '─' x ($width + $margin + $gap) . '╯', $color) . "\n";
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

