#!/usr/bin/perl
use Term::ANSIColor;

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

sub get_shell {
    return (split '/', $ENV{SHELL})[-1];
}

sub packages {
    my $pacs = `pacman -Q`;
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
    my $wm = get_wm();
    my $sh = get_shell();
    my $upt = uptime();
    my $pac = packages();
    my $usg = usage();

    my $width = 24 - 11;

    # format os => "OS        EndeavourOS  "
    $os = green('OS' . ' ' x 8) . $os . ' ' x ($width - length $os);

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

    $info[0] = ' ' x ($width + 10);
    $info[1] = $os;
    $info[2] = $wm;
    $info[3] = $sh;
    $info[4] = $upt;
    $info[5] = $pac;
    $info[6] = $usg;
    $info[7] = ' ' x ($width + 10);

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

