#!/usr/bin/perl

use Term::ANSIColor;
use Getopt::Long;

my $length = 25 - 12;
my $gap = 3;
my $margin = 2;
my $color = 'yellow';
my $wally;

my @colors = (
    'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
    'bright_red', 'bright_green', 'bright_yellow',
    'bright_blue', 'bright_magenta', 'bright_cyan', 'bright_white'
);

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
    my %info = %{(shift)};
    # format => "MARGIN PLACEHOLDER GAP NAME "
    my $text = ' ' x $margin . colored($info{'placeholder'}, $info{'color'});
    $text .= ' ' x (7 + $gap - length $info{'placeholder'});
    $text .= $info{'name'} . ' ' x ($length - length $info{'name'});

    return $text;
}

sub get_info {
    my $os = get_os();
    my $ke = kernel();
    my $de = get_de();
    my $sh = shell();
    my $up = uptime();
    my $pac = packages();
    my $de_placeholder = 'DE';
    my $not_de;
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
        "length=i" => \$length,
        "gap=i" => \$gap,
        "color=s" => \$color,
        "not_de" => \$not_de,
        "wally" => \$wally,
    );

    if($help) {
        print_help();
    }

    if($not_de) {
        $de_placeholder = 'WM';
    }

    if($color eq "random") {
        $color = @colors[int(rand scalar @colors)];
    }

    %os = (
        'placeholder' => 'OS',
        'color' => 'bright_green',
        'name' => $os,
    );

    %ke = (
        'placeholder' => 'KERNEL',
        'color' => 'blue',
        'name' => $ke,
    );

    %de = (
        'placeholder' => $de_placeholder,
        'color' => 'bright_red',
        'name' => $de,
    );

    %sh = (
        'placeholder' => 'SHELL',
        'color' => 'yellow',
        'name' => $sh,
    );

    %up = (
        'placeholder' => 'UPTIME',
        'color' => 'bright_magenta',
        'name' => $up,
    );

    %pac = (
        'placeholder' => 'PACKAGE',
        'color' => 'cyan',
        'name' => $pac,
    );

    $os = format_info(\%os);
    $ke = format_info(\%ke);
    $de = format_info(\%de);
    $sh = format_info(\%sh);
    $up = format_info(\%up);
    $pac = format_info(\%pac);

    my $i = 0;
    $info[$i++] = ' ' x ($length + $gap + 7 + $margin);
    $info[$i++] = $os;
    $info[$i++] = $ke;
    $info[$i++] = $de;
    $info[$i++] = $sh;
    $info[$i++] = $up;
    $info[$i++] = $pac;
    $info[$i++] = ' ' x ($length + $gap + 7 + $margin);

    return $info;
}

sub main {
    my $info = get_info();
    my $text = "\n";

    if($wally) {
        $text .= colored('                 ╭' . '─' x ($length + $margin + $gap + 7) . '╮', $color) . "\n";
        $text .= colored("     .-'''-.     │", $color) . $info[0] . colored('│', $color) . "\n";
        $text .= colored('    |       |    │', $color) . $info[1] . colored('│', $color) . "\n";
        $text .= colored('   ⪜|---_---|⪛  ╭│', $color) . $info[2] . colored('│', $color) . "\n";
        $text .= colored('   Ͼ|__(_)__|Ͽ  ││', $color) . $info[3] . colored('│', $color) . "\n";
        $text .= colored('    |   _   |   ││', $color) . $info[4] . colored('│', $color) . "\n";
        $text .= colored('    |       |   ╯│', $color) . $info[5] . colored('│', $color) . "\n";
        $text .= colored('   ˏ====○====ˎ   │', $color) . $info[6] . colored('│', $color) . "\n";
        $text .= colored('       / \       │', $color) . $info[7] . colored('│', $color) . "\n";
        $text .= colored('                 ╰' . '─' x ($length + $margin + $gap + 7) . '╯', $color) . "\n";
    } else {
        $text .= colored('              ╭' . '─' x ($length + $margin + $gap + 7) . '╮', $color) . "\n";
        $text .= colored('    დოოოოოდ   │', $color) . $info[0] . colored('│', $color) . "\n";
        $text .= colored('    |     |   │', $color) . $info[1] . colored('│', $color) . "\n";
        $text .= colored('    |     |  ╭│', $color) . $info[2] . colored('│', $color) . "\n";
        $text .= colored('    |-ᱛ ᱛ-|  ││', $color) . $info[3] . colored('│', $color) . "\n";
        $text .= colored('   Ͼ   ∪   Ͽ ││', $color) . $info[4] . colored('│', $color) . "\n";
        $text .= colored('    |     |  ╯│', $color) . $info[5] . colored('│', $color) . "\n";
        $text .= colored('   ˏ`-.ŏ.-´ˎ  │', $color) . $info[6] . colored('│', $color) . "\n";
        $text .= colored('       @      │', $color) . $info[7] . colored('│', $color) . "\n";
        $text .= colored('        @     ╰' . '─' x ($length + $margin + $gap + 7) . '╯', $color) . "\n";
    }

    $text .= "\n";
    print $text;
}

sub print_help {
    print "usage: fm6000 [options]\n\n";
    print "-c, --color=STR    Base color\n\n";
    print "-w, --wally    Display Wally \n\n";
    print "-n, --not_de    To use 'WM' instead of 'DE'\n\n";
    print "-o, --os=STR    OS name\n\n";
    print "-k or --kernel=STR    Kernel version\n\n";
    print "-d or --de=STR    Desktop environment name\n\n";
    print "-s or --shell=STR    Shell name\n\n";
    print "-u or --uptime=STR    Uptime\n\n";
    print "-p or --package=INT    Number of packages\n\n";
    print "-m or --margin=INT    Spaces on the left side of info\n\n";
    print "-g or --gap=INT    Spaces between info and info_value\n\n";
    print "-l or --length=INT    Length of the board ( > 14)\n\n";
    print "available colors: \n";
    print join(", ", splice(@colors, 0, 7)) . ", random" . "\n";
    print join(", ", @colors) . "\n\n";

    exit;
}

main();

