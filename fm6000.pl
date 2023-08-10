#!/usr/bin/env perl

# Dilbert themed system info fetch tool
# https://github.com/anhsirk0/fetch-master-6000

use strict;
use Term::ANSIColor;
use Getopt::Long;
use Text::Wrap;
use POSIX;

my $width = 13;
my $gap = 10;
my $margin = 2;
my $color = 'yellow';

my @info;
my $os;
my $ke;
my $de;
my $sh;
my $up;
my $pac;
my $de_placeholder = 'DE';
my $vnstat = '-1';
my $usg;

my $wally;
my $dogbert;
my $alice;
my $phb;
my $asok;
my $help;
my $not_de;
my $random;
my $random_dir;
my $ascii_file;
my $say;
my $say_file;

my @colors = ( # do not add 'random' here
    'red', 'green', 'yellow', 'blue', 'magenta', 'cyan',
    'bright_red', 'bright_green', 'bright_yellow', 'bright_blue',
    'bright_magenta', 'bright_cyan',
    );

my @wm = (
    '2bwm', '9wm', 'Finder', 'awesome', 'berry', 'beryl', 'blackbox', 'bspwm',
    'budgie-wm', 'chromeos-wm', 'compiz', 'deepin-wm', 'dminiwm', 'dtwm', 'dwm',
    'e16', 'echinus', 'emerald', 'enlightenment', 'fluxbox', 'flwm',
    'flwm_topside', 'fvwm', 'herbstluftwm', 'howm', 'i3', 'icewm', 'instawm',
    'kwin', 'leftwm', 'metacity', 'monsterwm', 'musca', 'mwm', 'none+leftwm',
    'notion', 'openbox', 'pekwm', 'qtile', 'ratpoison', 'sawfish', 'scrotwm',
    'spectrwm', 'stumpwm', 'subtle', 'sway', 'swm', 'twin', 'wmaker', 'wmfs',
    'wmii', 'xfwm4', 'xmonad',
    );

my $GREEN  = "bright_green";
my $YELLOW = "yellow";
my $BLUE   = "bright_blue";    # for string args

sub get_os {
    my $os = `lsb_release -si 2>/dev/null`;
    unless ($os) {
        if (open(FH, "<", "/etc/os-release")) {
            while(<FH>) {
                next unless ($_ =~ m/^NAME/);
                $os = $_;
                $os =~ s/NAME=//;
                last;
            }
        }
    }
    # for gentoo
    unless ($os) { $os = `[ -x "/etc/portage" ] && echo "Gentoo" 2>/dev/null` }
    # for BSD
    unless ($os) { $os = `uname -s 2>/dev/null` }
    s/ Linux//i, s/"|'//g, chomp for ($os);
    # Check for mac os
    if ($os eq "Darwin") { $os = "OSX"; }
    return $os || "Unknown";
}

sub get_de {
    my $de = $ENV{DESKTOP_SESSION} || $ENV{XDG_SESSION_DESKTOP};
    unless ($de) { $de = $ENV{XDG_CURRENT_DESKTOP} }
    unless ($de) {
        # checking WM through `ps`
        my $ps_flags = ($os =~ /bsd/i) ? "x -c" : "-e";
        my $ps = `ps $ps_flags`;
        ($de) = $ps =~ /(2bwm|tinywm|fvwm|monsterwm|catwm|sowm|openbox|sway)/i;
    }
    unless ($de) {
        # checking WM through `wmctrl`
        my $wmctrl = `wmctrl -m`;
        ($de) = $wmctrl =~ /Name : (.*)/;
    }
    unless($de) { $de = "Apple Inc." if ($os eq "OSX"); }
    return $de || "Unknown";
}

sub get_shell {
    my $sh = (split '/', $ENV{SHELL})[-1];
    return $sh || "Unknown";
}

sub get_kernel {
    my $ke = `uname -r`;
    s/-.*//, chomp for ($ke);
    return $ke || "Unknown";
}

sub get_packages {
    # for debian based
    my $pacs = `dpkg-query -l 2>/dev/null | grep "^ii"`;
    # for arch based
    unless ($pacs) { $pacs = `pacman -Q 2>/dev/null` }
    # for fedora
    unless ($pacs) { $pacs = `yum list installed 2>/dev/null` }
    # for BSD
    unless ($pacs) { $pacs = `pkg info 2>/dev/null` }
    # for gentoo based
    unless ($pacs) { $pacs = `ls -d /var/db/pkg/*/* 2>/dev/null` }
    # for KISS linux
    unless ($pacs) { $pacs = `ls -d /var/db/kiss/installed/* 2>/dev/null` }
    # for venon linux
    unless ($pacs) { $pacs = `ls -d /var/lib/scratchpkg/db/* 2>/dev/null` }
    # for solus
    unless ($pacs) { $pacs = `ls /var/lib/eopkg/package/ 2>/dev/null` }
    # for void linux
    unless ($pacs) { $pacs = `xbps-query -l 2>/dev/null` }
    # for OpenSUSE
    unless ($pacs) { $pacs = `rpm -qa 2>/dev/null` }
    # for nixos
    unless ($pacs) { $pacs = `nix-store -qR /run/current-system/sw/ 2>/dev/null && nix-store -qR ~/.nix-profile/ 2>/dev/null` }
    # for OSX
    unless ($pacs) { $pacs = `brew list 2>/dev/null` }

    my $count = $pacs =~ tr/\n//;
    return $count || "Unknown";
}

sub get_uptime {
    my $seconds;
    my $now = time();
    # macOS
    if ($os eq "OSX") {
        my $boot = `sysctl -n kern.boottime`;
        ($boot) = $boot =~ /{ sec = (\d+)/;
        $seconds = $now - $boot;
    } else {
        # For Linux/BSD
        if (open(FH, "<" . "/proc/uptime")) {
            chomp($seconds = <FH>);
            close(FH);
            $seconds =~ s/\.*$//;
            $seconds = int($seconds);
        } elsif ($os =~ m/BSD/i) {
            my $boot = `sysctl -n kern.boottime`;
            $seconds = $now - $boot;
        } else {
            my $boot = `date -d "\$(uptime -s)" +%s`;
            $seconds = $now - $boot;
        }
    }

    my $d = int($seconds / 60 / 60 / 24);
    my $h = $seconds / 60 / 60 % 24;
    my $m = $seconds / 60 % 60;
    my $time = $d . "d, " . $h . "h, " . $m . "m";
    $time =~ s/0., //g;
    return $time;
}

# today's internet usage via vnstat
sub get_usage {
    my $data = `vnstat`;
    my $today;
    foreach my $line (split '\n', $data) {
        next unless ($line =~ /today/);
        $line =~ s/\|/\//g; # newer vnstat uses | as separator
        $today = (split '/', $line)[2];
        $today =~ s/^ *//;
        last;
    }
    return $today || "Unknown";
}

sub format_info {
    my %info = %{(shift)};
    # format => "MARGIN PLACEHOLDER GAP NAME"
    my $text = ' ' x $margin . colored($info{'placeholder'}, $info{'color'});
    $text .= ' ' x ($gap - length $info{'placeholder'});
    $text .= $info{'name'} . ' ' x ($width - length $info{'name'});
    return $text;
}

sub get_random_file {
    if (-d $random_dir) {
        my @files = glob($random_dir . "/*");
        return @files[int(rand scalar @files)]
    } 
    print "Please provide a Directory\n";
    exit(1);
}

sub get_info {
    GetOptions (
        "help|h" => \$help,
        "os|o=s" => \$os,
        "kernel|k=s" => \$ke,
        "de|d=s" => \$de,
        "shell|sh=s" => \$sh,
        "uptime|u=s" => \$up,
        "packages|p=i" => \$pac,
        "margin|m=i" => \$margin,
        "length|l=i" => \$width,
        "gap|g=i" => \$gap,
        "color|c=s" => \$color,
        "not-de|nd" => \$not_de,
        "vnstat|v:s" => \$vnstat,
        "wally|w" => \$wally,
        "dogbert|dog" => \$dogbert,
        "alice|al" => \$alice,
        "phb" => \$phb,
        "asok|as" => \$asok,
        "random|r" => \$random,
        "random-dir|rd=s" => \$random_dir,
        "file|f=s" => \$ascii_file,
        "say|s=s" => \$say,
        "say-file|sf=s" => \$say_file,
        );

    print_help_and_exit() if ($help);

    $color = @colors[int(rand scalar @colors)] if ($color eq "random");

    if ($say_file) {
        open (FH, "<", $say_file) or die "Unable to open $say_file";
        while (<FH>) { $say .= $_ }
        close(FH);
        chomp $say;
    }

    if ($say) {
        my $total_length = $width + $gap - $margin; # total length of the text box
        my $total_chars =  length($say) + 10 * $margin; # including margin on each line

        if ($total_chars / $total_length > 8) {
            $width = $width + ceil(1.6 * $total_chars / $total_length);
        }

        $Text::Wrap::columns = $width + $gap - $margin;
        my @new_info;
        @info = split "\n", wrap("" , "", $say);

        my $number_of_lines = scalar @info;
        for my $i (0 .. ($number_of_lines - 1)) {
            $new_info[$i] = " " x $margin . $info[$i] . " " x ($width + $gap - length $info[$i]);
        }
        # if say text is less than 6 lines we can add two empty lines (at start and end)
        if ($number_of_lines <= 6) {
            unshift(@new_info, " " x ($width + $gap + $margin));
            push(@new_info, " " x ($width + $gap + $margin));
        }
        return @new_info;
    }

    unless ($os) { $os = get_os(); }
    unless ($ke) { $ke = get_kernel(); }
    unless ($de) { $de = get_de(); }
    unless ($sh) { $sh = get_shell(); }
    unless ($up) { $up = get_uptime(); }
    unless ($pac) { $pac = get_packages(); }

    $de_placeholder = 'WM' if ($not_de || grep(/^$de$/i, @wm));
    $vnstat = get_usage() if ($vnstat eq '');

    my %usg = (
        'placeholder' => 'VNSTAT',
        'color'       => 'magenta',
        'name'        => $vnstat,
        );
    my %os = (
        'placeholder' => 'OS',
        'color'       => 'bright_green',
        'name'        => $os,
        );
    my %ke = (
        'placeholder' => 'KERNEL',
        'color'       => 'blue',
        'name'        => $ke,
        );
    my %de = (
        'placeholder' => $de_placeholder,
        'color'       => 'bright_magenta',
        'name'        => $de,
        );
    my %sh = (
        'placeholder' => 'SHELL',
        'color'       => 'yellow',
        'name'        => $sh,
        );
    my %up = (
        'placeholder' => 'UPTIME',
        'color'       => 'magenta',
        'name'        => $up,
        );
    my %pac = (
        'placeholder' => 'PACKAGES',
        'color'       => 'cyan',
        'name'        => $pac,
        );

    $os = format_info(\%os);
    $ke = format_info(\%ke);
    $de = format_info(\%de);
    $sh = format_info(\%sh);
    $up = format_info(\%up);
    $pac = format_info(\%pac);
    $usg = format_info(\%usg);

    my $i = 0;
    $info[$i++] = ' ' x ($width + $gap + $margin);
    $info[$i++] = $os;
    if ($vnstat eq '-1' ) { $info[$i++] = $ke; }
    $info[$i++] = $de;
    $info[$i++] = $sh;
    $info[$i++] = $up;
    $info[$i++] = $pac;
    unless ($vnstat eq '-1' ) { $info[$i++] = $usg }
    $info[$i++] = ' ' x ($width + $gap + $margin);

    return @info;
}

sub main {
    my @info = get_info();

    if ($random) {
        my @arr = map { 0 } (1..6);
        $arr[int rand(6)] = 1;
        ($wally, $dogbert, $alice, $phb, $asok) = splice @arr, 0, 4;
    }

    my @info_lines = (); # info about os, wm etc etc

    for my $i (0 .. scalar @info - 1) {
        $info_lines[$i] = colored(q{│}, $color) . $info[$i] . colored('│', $color),
    }
    unshift(@info_lines, colored(q{╭} . '─' x ($width + $margin + $gap) . '╮', $color));
    push(@info_lines, colored(q{╰} . '─' x ($width + $margin + $gap) . '╯', $color));

    # select random file from given Directory
    if ($random_dir) { $ascii_file = get_random_file() }

    # read ascii file
    my $i = 0;
    my $text = "\n";
    if ($ascii_file) {
        open (FH, "<", $ascii_file) or die "Unable to open $ascii_file";
        chomp(my @ascii =  <FH>);
        close(FH);
        my $offset = abs int(scalar @ascii / 2 - 5); # to keep info in middle

        for (my $i = 0; $i < scalar @ascii; $i++) {
            my $j = $i - $offset;
            if ($j >= 0 && $j < 10) { # info is of 10 lines
                $text .= colored($ascii[$i], $color) . $info_lines[$j] . "\n";
            } else {
                $text .= colored($ascii[$i], $color) . "\n";
            }
        }
    } elsif ($wally) {
        $text .= colored(q{                  }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{     .-'''-.      }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |       |     }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   ⪜|---_---|⪛   ╭}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   Ͼ|__(_)__|Ͽ   │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |   _   |    │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |       |    ╯}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   ˏ====○====ˎ    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{       / \        }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{                  }, $color) . $info_lines[$i++] . "\n";
    } elsif ($dogbert) {
        $text .= colored(q{                 }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{                 }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    .-----.      }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{  .`       `.   ╭}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{ / /-() ()-\ \  │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{ \_|   ○   |_/  │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{  '.       .'   ╯}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    `-._.-'      }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{                 }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{                 }, $color) . $info_lines[$i++] . "\n";
    } elsif ($alice) {
        $text .= colored(q{           ..-..             }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{         (~     ~)           }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{       (           )         }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{     (    ~~~~~~~    )      ╭}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   (     |  . .  |     )    │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{  (      |  (_)  |      )   │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{ (       |       |       )  ╯}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   (.,.,.|  ===  |.,.,.)     }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{          '.___.'            }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{           /   \             }, $color) . $info_lines[$i++] . "\n";
    } elsif ($phb) {
        $text .= colored(q{   @         @     }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{  @@  ..-..  @@    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{  @@@' _ _ '@@@    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   @(  . .  )@    ╭}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |  (_)  |     │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |   _   |     │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |_     _|     ╯}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   /|_'---'_|\     }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{  / | '\_/' | \    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{ /  |  | |  |  \   }, $color) . $info_lines[$i++] . "\n";
    } elsif ($asok) {
        $text .= colored(q{                 }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    @@@@@@@@@    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |       |    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    | _   _ |   ╭}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   Ͼ| ○   ○ |Ͽ  │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |   u   |   │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |  ---  |   ╯}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   / `-._.-´ \   }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{        |        }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{                 }, $color) . $info_lines[$i++] . "\n";
    } else {
        $text .= colored(q{               }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    დოოოოოდ    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |     |    }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |     |   ╭}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |-Ο Ο-|   │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   Ͼ   ∪   Ͽ  │}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{    |     |   ╯}, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{   ˏ`-.ŏ.-´ˎ   }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{       @       }, $color) . $info_lines[$i++] . "\n";
        $text .= colored(q{        @      }, $color) . $info_lines[$i++] . "\n";
    }

    print $text . "\n";
}

sub format_option {
    my ($short, $long, $desc, $args, $default) = @_;
    $default ||= 0;
    my $long_info = colored("--" . $long, $GREEN) .
        ($args > 0 && colored(" <" . uc $long . ">", $GREEN));
    my $long_width = length($long) * ($args + 1);

    $long_info .= "\t";
    if ($long_width < 16) { $long_info .= "\t" }
    if ($long_width < 8) { $long_info .= "\t" }
    my $text = "\t" . colored("-" . $short, $GREEN);
    $text .= ", " . $long_info;
    $text .= $desc . ($default ne 0 && " [default: " . $default . "]");
    return $text . "\n";
}

sub print_help_and_exit {
    printf(
        "%s\n%s\n\n%s\n\n%s\n" . # About, Usage
        "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n" . # Options list
        "%s\n%s\n%s\n" . # Colors
        "%s\n%s\n%s\n%s\n", # Examples
        colored("fm6000", $GREEN),
        "Dilbert themed system info fetching tool.",
        colored("USAGE:", $YELLOW) . "\n\t" . "fm6000 [OPTIONS]",
        colored("OPTIONS:", $YELLOW),
        format_option("h", "help", "Print help information", 0),
        format_option("c", "color", "Base color", 1),
        format_option("w", "wally", "Display wally", 0),
        format_option("h", "help", "Print help information", 0),
        format_option("dog", "dogbert", "Display Dogbert", 0),
        format_option("al", "alice", "Display Alice", 0),
        format_option("phb", "phb", "Display Pointy haired Boss", 0),
        format_option("as", "asok", "Display Asok", 0),
        format_option("nd", "not-de", "To use label 'WM' instead of 'DE'", 0),
        format_option("o", "os", "OS name", 1),
        format_option("k", "kernel", "Kernel version", 1),
        format_option("d", "de", "Desktop environment name", 1),
        format_option("sh", "shell", "Shell name", 1),
        format_option("u", "uptime", "Uptime", 1),
        format_option("p", "package", "Number of packages", 1),
        format_option("v", "vnstat", "Show vnstat info instead of kernel", 1),
        format_option("r", "random", "Display Random Art", 0),
        format_option("rd", "random-dir", "Directory for random ascii art", 1),
        format_option("f", "file", "Display art from file", 1),
        format_option("s", "say", "Say provided text", 1),
        format_option("sf", "say-file", "Say text from a file", 1),
        format_option("m", "margin", "Spaces on the left side of info", 1),
        format_option("g", "gap", "Gap between label and value", 1, 10),
        format_option("l", "length", "Length of the Box", 1, 13),
        colored("COLORS:", $YELLOW),
        "\t" . join(", ", splice(@colors, 0, 8)),
        "\t" . join(", ", @colors) . ", random\n",
        colored("EXAMPLES:", $YELLOW),
        "\tfm6000 --wally --color blue",
        "\tfm6000 --random --color random",
        "\tfm6000 --say 'Hello World!'",
        );
    exit;
}

main();
