#!/usr/bin/perl
use Term::ANSIColor;

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

sub get_wm {
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
    unless($pacs){
        $pacs = `dpkg-query`;
    }
    # for fedora
    unless($pacs){
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

sub usage {
    my $data = `vnstat`;
    unless($data){
        return 'empty'
    }
    my $today = 0;
    foreach my $line (split '\n', $data) {
        if ($line =~ /today/) {
            $today = (split '\|', $line)[2];
            $today =~ s/^ *//;
        }
    }
    return $today;
}

sub get_info {
    my $os = get_os();
    my $ke = kernel();
    my $wm = get_wm();
    my $sh = shell();
    my $upt = uptime();
    my $pac = packages();
    my $usg = usage();

    my $width = 25 - 12;

    # format os => "OS        EndeavourOS  "
    $os = green('OS' . ' ' x 8) . $os . ' ' x ($width - length $os);

    # format kernel => "KERNEL        5.11.9        "
    $ke = blue('KERNEL' . ' ' x 4) . $ke . ' ' x ($width - length $ke);

    # format wm => "WM        awesome        "
    $wm = yellow('WM' . ' ' x 8) . $wm . ' ' x ($width - length $wm);

    # format shell => "SHELL     fish        "
    $sh = green('SHELL' . ' ' x 5) . $sh . ' ' x ($width - length $sh);

    # format uptime => "UPTIME   17h, 29m      "
    $upt = magenta('UPTIME' . ' ' x 4) . $upt . ' ' x ($width - length $upt);

    # format packages => "PACKAGE   314         "
    $pac = blue('PACKAGE' . ' ' x 3) . $pac . ' ' x ($width - length $pac);

    # format vnstat => "VNSTAT   1.61 GiB         "
    $usg = orange('VNSTAT' . ' ' x 4) . $usg . ' ' x ($width - length $usg);

    my $i = 0;
    $info[$i++] = ' ' x ($width + 10);
    $info[$i++] = $os;
    $info[$i++] = $ke;
    $info[$i++] = $wm;
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

dilbert();

