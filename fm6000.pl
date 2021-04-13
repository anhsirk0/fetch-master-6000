#!/usr/bin/perl

# Dilbert themed system info fetch tool
# https://github.com/anhsirk0/fetch-master-6000

use Term::ANSIColor;
use Getopt::Long;

my $length = 13;
my $gap = 3;
my $margin = 2;
my $color = 'yellow';

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
    foreach(split '\n', $pacs) {
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

# today's internet usage via vnstat
sub usage {
    my $data = `vnstat`;
    foreach my $line (split '\n', $data) {
        if ($line =~ /today/) {
            $today = (split '\|', $line)[2];
            $today =~ s/^ *//;
        }
    }
    return $today;
}

sub format_info {
    my %info = %{(shift)};
    # format => "MARGIN PLACEHOLDER GAP NAME"
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
    my $vnstat = '-1';

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
        "vnstat:s" => \$vnstat,
        "wally" => \$wally,
        "dogbert" => \$dogbert,
    );

    if($help) {
        print_help();
        exit;
    }

    if($not_de) {
        $de_placeholder = 'WM';
    }

    if($vnstat eq '') {
        $vnstat = usage();
    }

    if($color eq "random") {
        $color = @colors[int(rand scalar @colors)];
    }

    %usg = (
        'placeholder' => 'VNSTAT',
        'color' => 'magenta',
        'name' => $vnstat
    );

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
    $usg = format_info(\%usg);

    my $i = 0;
    $info[$i++] = ' ' x ($length + $gap + 7 + $margin);
    $info[$i++] = $os;
    if($vnstat eq '-1' ) { $info[$i++] = $ke; }
    $info[$i++] = $de;
    $info[$i++] = $sh;
    $info[$i++] = $up;
    $info[$i++] = $pac;
    unless($vnstat eq '-1' ) { $info[$i++] = $usg; }
    $info[$i++] = ' ' x ($length + $gap + 7 + $margin);

    return $info;
}

sub main {
    my $info = get_info();
    my $text = "\n";

    if($wally) {
        $text .= colored(q{                 ╭} . '─' x ($length + $margin + $gap + 7) . '╮', $color) . "\n";
        $text .= colored(q{     .-'''-.     │}, $color) . $info[0] . colored('│', $color) . "\n";
        $text .= colored(q{    |       |    │}, $color) . $info[1] . colored('│', $color) . "\n";
        $text .= colored(q{   ⪜|---_---|⪛  ╭│}, $color) . $info[2] . colored('│', $color) . "\n";
        $text .= colored(q{   Ͼ|__(_)__|Ͽ  ││}, $color) . $info[3] . colored('│', $color) . "\n";
        $text .= colored(q{    |   _   |   ││}, $color) . $info[4] . colored('│', $color) . "\n";
        $text .= colored(q{    |       |   ╯│}, $color) . $info[5] . colored('│', $color) . "\n";
        $text .= colored(q{   ˏ====○====ˎ   │}, $color) . $info[6] . colored('│', $color) . "\n";
        $text .= colored(q{       / \       │}, $color) . $info[7] . colored('│', $color) . "\n";
        $text .= colored(q{                 ╰} . '─' x ($length + $margin + $gap + 7) . '╯', $color) . "\n";
    } elsif ($dogbert) {
        $text .= colored(q{                ╭} . '─' x ($length + $margin + $gap + 7) . '╮', $color) . "\n";
        $text .= colored(q{                │}, $color) . $info[0] . colored('│', $color) . "\n";
        $text .= colored(q{    .-----.     │}, $color) . $info[1] . colored('│', $color) . "\n";
        $text .= colored(q{  .`       `.  ╭│}, $color) . $info[2] . colored('│', $color) . "\n";
        $text .= colored(q{ / /-() ()-\ \ ││}, $color) . $info[3] . colored('│', $color) . "\n";
        $text .= colored(q{ \_|   ○   |_/ ││}, $color) . $info[4] . colored('│', $color) . "\n";
        $text .= colored(q{  '.       .'  ╯│}, $color) . $info[5] . colored('│', $color) . "\n";
        $text .= colored(q{    `-._.-'     │}, $color) . $info[6] . colored('│', $color) . "\n";
        $text .= colored(q{                │}, $color) . $info[7] . colored('│', $color) . "\n";
        $text .= colored(q{                ╰} . '─' x ($length + $margin + $gap + 7) . '╯', $color) . "\n";
    } else {
        $text .= colored(q{              ╭} . '─' x ($length + $margin + $gap + 7) . '╮', $color) . "\n";
        $text .= colored(q{    დოოოოოდ   │}, $color) . $info[0] . colored('│', $color) . "\n";
        $text .= colored(q{    |     |   │}, $color) . $info[1] . colored('│', $color) . "\n";
        $text .= colored(q{    |     |  ╭│}, $color) . $info[2] . colored('│', $color) . "\n";
        $text .= colored(q{    |-ᱛ ᱛ-|  ││}, $color) . $info[3] . colored('│', $color) . "\n";
        $text .= colored(q{   Ͼ   ∪   Ͽ ││}, $color) . $info[4] . colored('│', $color) . "\n";
        $text .= colored(q{    |     |  ╯│}, $color) . $info[5] . colored('│', $color) . "\n";
        $text .= colored(q{   ˏ`-.ŏ.-´ˎ  │}, $color) . $info[6] . colored('│', $color) . "\n";
        $text .= colored(q{       @      │}, $color) . $info[7] . colored('│', $color) . "\n";
        $text .= colored(q{        @     ╰} . '─' x ($length + $margin + $gap + 7) . '╯', $color) . "\n";
    }

    $text .= "\n";
    print $text;
}

sub print_help {
    print "usage: fm6000 [options]\n\n";
    print "-c, --color=STR    Base color\n";
    print "-w, --wally    Display Wally \n";
    print "-dog, --dogbert    Display Dogbert \n";
    print "-n, --not_de    To use 'WM' instead of 'DE'\n";
    print "-o, --os=STR    OS name\n";
    print "-k or --kernel=STR    Kernel version\n";
    print "-de or --de=STR    Desktop environment name\n";
    print "-s or --shell=STR    Shell name\n";
    print "-u or --uptime=STR    Uptime\n";
    print "-p or --package=INT    Number of packages\n";
    print "-v or --vnstat=STR    Use vnstat instead of kernel\n";
    print "-m or --margin=INT    Spaces on the left side of info\n";
    print "-g or --gap=INT    Spaces between info and info_value\n";
    print "-l or --length=INT    Length of the board ( > 14)\n\n";
    print "available colors: \n";
    print join(", ", splice(@colors, 0, 7)) . ", random" . "\n";
    print join(", ", @colors) . "\n";
}

main();

