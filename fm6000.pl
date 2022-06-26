#!/usr/bin/env perl

# Dilbert themed system info fetch tool
# https://github.com/anhsirk0/fetch-master-6000

use strict;
use Term::ANSIColor;
use Getopt::Long;
use Text::Wrap;
use experimental 'smartmatch';
use POSIX;

my $length = 13;
my $gap = 3;
my $margin = 2;
my $color = 'yellow';

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
    'fluxbox', 'openbox', 'blackbox', 'xfwm4', 'metacity', 'kwin', 'twin', 'icewm',
    'pekwm', 'flwm', 'flwm_topside', 'fvwm', 'dwm', 'awesome', 'wmaker', 'stumpwm',
    'musca', 'xmonad', 'i3', 'ratpoison', 'scrotwm', 'spectrwm', 'wmfs', 'wmii',
    'beryl', 'subtle', 'e16', 'enlightenment', 'sawfish', 'emerald', 'monsterwm',
    'dminiwm', 'compiz', 'Finder','herbstluftwm', 'howm', 'notion', 'bspwm', '2bwm',
    'echinus', 'swm', 'budgie-wm', 'dtwm', '9wm', 'chromeos-wm', 'deepin-wm', 'sway',
    'mwm', 'instawm', 'qtile', 'leftwm', 'none+leftwm'
    );

sub get_os {
    my $os = `lsb_release -si 2>/dev/null`;
    unless ($os) {
        my $os_release_file = "/etc/os-release";
        if (-f $os_release_file) {
            open(FH, "<", $os_release_file);
            while(<FH>) {
                if ($_ =~ m/^NAME/) {
                    $os = $_;
                    $os =~ s/NAME=//;
                    last;
                }
            }
        }
    }
    # for gentoo
    unless ($os) { $os = `[ -x "/etc/portage" ] && echo "Gentoo" 2>/dev/null` }
    # for BSD
    unless ($os) { $os = `uname -s 2>/dev/null` }
    unless ($os) { $os = "Unknown" }
    for($os) {
        s/ Linux//i;
        s/"|'//g;
        chomp;
    }
    return $os;
}

sub get_de {
    my $de = $ENV{DESKTOP_SESSION};
    unless ($de) { $de = $ENV{XDG_SESSION_DESKTOP} }
    unless ($de) { $de = $ENV{XDG_CURRENT_DESKTOP} }
    unless ($de) { $de = "Unknown" }
    return $de;
}

sub shell {
    my $sh = (split '/', $ENV{SHELL})[-1];
    unless ($sh) { $sh = "Unknown" }
    return $sh;
}

sub kernel {
    my $ke = `uname -r`;
    $ke =~ s/-.*//;
    chomp $ke;
    unless ($ke) { $ke = "Unknown" }
    return $ke;
}

sub packages {
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

    my $count = $pacs =~ tr/\n//;
    unless ($count) { $count = "Unknown" }
    return $count;
}

sub uptime {
    my $uptime = `uptime -s`;
    my $boot = `date -d"$uptime" +%s`;
    my $now = time();
    my $seconds = $now - $boot;

    my $d = int($seconds / 60 / 60 / 24);
    my $h = $seconds / 60 / 60 % 24;
    my $m = $seconds / 60 % 60;
    my $time = $d . "d, " . $h . "h, " . $m . "m";
    $time =~ s/0., //g;
    return $time;
}

# today's internet usage via vnstat
sub usage {
    my $data = `vnstat`;
    my $today;
    foreach my $line (split '\n', $data) {
        if ($line =~ /today/) {
            $line =~ s/\|/\//g; # newer vnstat uses | as separator
            $today = (split '/', $line)[2];
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

sub get_random_file {
    if (-d $random_dir) {
	my @files = glob($random_dir . "/*");
	return @files[int(rand scalar @files)]
    } else {
	print "Please provide a Directory\n";
	exit;
    }
}

sub get_info {
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

    GetOptions (
        "help|h" => \$help,
        "os|o=s" => \$os,
        "kernel|k=s" => \$ke,
        "de|d=s" => \$de,
        "shell|sh=s" => \$sh,
        "uptime|u=s" => \$up,
        "packages|p=i" => \$pac,
        "margin|m=i" => \$margin,
        "length|l=i" => \$length,
        "gap|g=i" => \$gap,
        "color|c=s" => \$color,
        "not_de|nd" => \$not_de,
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

    if ($help) {
        print_help();
        exit;
    }

    if ($color eq "random") {
        $color = @colors[int(rand scalar @colors)];
    }

    if ($say_file) {
        open (FH, "<", $say_file) or die "Unable to open $say_file";
	while (<FH>) { $say .= $_ }
	close(FH);
	chomp $say;
    }

    if ($say) {
        my $total_length = $length + $gap + 7 - $margin; # total length of the text box
        my $total_chars =  length($say) + 10 * $margin; # including margin on each line

        if ($total_chars / $total_length > 8) {
            $length = $length + ceil(1.6 * $total_chars / $total_length);
        }

        $Text::Wrap::columns = $length + $gap + 7 - $margin;
        my @new_info;
        @info = split "\n", wrap("" , "", $say);

        my $number_of_lines = scalar @info;
        for my $i (0 .. ($number_of_lines - 1)) {
            $new_info[$i] = " " x $margin . $info[$i] . " " x ($length + $gap + 7 - length $info[$i]);
        }
        # if say text is less than 6 lines we can add two empty lines (at start and end)
        if ($number_of_lines <= 6) {
            unshift(@new_info, " " x ($length + $gap + 7 + $margin));
            push(@new_info, " " x ($length + $gap + 7 + $margin));
        }
        return @new_info;
    }

    unless ($os) { $os = get_os(); }
    unless ($ke) { $ke = kernel(); }
    unless ($de) { $de = get_de(); }
    unless ($sh) { $sh = shell(); }
    unless ($up) { $up = uptime(); }
    unless ($pac) { $pac = packages(); }

    if ($not_de) {
        $de_placeholder = 'WM';
    }

    if ($de ~~ @wm) {
        $de_placeholder = 'WM';
    }

    if ($vnstat eq '') {
        $vnstat = usage();
    }

    my %usg = (
        'placeholder' => 'VNSTAT',
        'color' => 'magenta',
        'name' => $vnstat,
        );

    my %os = (
        'placeholder' => 'OS',
        'color' => 'bright_green',
        'name' => $os,
        );

    my %ke = (
        'placeholder' => 'KERNEL',
        'color' => 'blue',
        'name' => $ke,
        );

    my %de = (
        'placeholder' => $de_placeholder,
        'color' => 'bright_magenta',
        'name' => $de,
        );

    my %sh = (
        'placeholder' => 'SHELL',
        'color' => 'yellow',
        'name' => $sh,
        );

    my %up = (
        'placeholder' => 'UPTIME',
        'color' => 'magenta',
        'name' => $up,
        );

    my %pac = (
        'placeholder' => 'PACKAGES',
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
    if ($vnstat eq '-1' ) { $info[$i++] = $ke; }
    $info[$i++] = $de;
    $info[$i++] = $sh;
    $info[$i++] = $up;
    $info[$i++] = $pac;
    unless ($vnstat eq '-1' ) { $info[$i++] = $usg }
    $info[$i++] = ' ' x ($length + $gap + 7 + $margin);

    return @info;
}

sub main {
    my @info = get_info();

    if ($random) {
        my @arr = map { 0 } (1..6);
        $arr[int rand(6)] = 1;
        ($wally, $dogbert, $alice, $phb, $asok) = splice @arr, 0, 4;
    }

    # my $i = 0;
    my @info_lines = (); # info about os, wm etc etc

    for my $i (0 .. scalar @info - 1) {
        $info_lines[$i] = colored(q{│}, $color) . $info[$i] . colored('│', $color),
    }
    unshift(@info_lines, colored(q{╭} . '─' x ($length + $margin + $gap + 7) . '╮', $color));
    push(@info_lines, colored(q{╰} . '─' x ($length + $margin + $gap + 7) . '╯', $color));

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

    $text .= "\n";
    print $text;
}

sub print_help {
    my $help_text = qq{usage: fm6000 [options]\n
    -c, --color=STR \t\t Base color
    -w, --wally \t\t Display Wally
    -dog, --dogbert \t\t Display Dogbert
    -al, --alice \t\t Display Alice
    -phb, --phb \t\t Display Pointy haired Boss
    -as, --asok \t\t Display Asok
    -nd, --not_de \t\t To use 'WM' instead of 'DE'
    -o, --os=STR \t\t OS name
    -k, --kernel=STR \t\t Kernel version
    -d, --de=STR \t\t Desktop environment name
    -sh, --shell=STR \t\t Shell name
    -u, --uptime=STR \t\t Uptime
    -p, --package=INT \t\t Number of packages
    -v, --vnstat=STR \t\t Use vnstat instead of kernel
    -f, --file \t\t\t Display art from file
    -r, --random \t\t Display Random Art
    -rd, --random-dir=STR \t Directory for random ascii art
    -s, --say=STR \t\t Say provided text instead of info
    -sf, --say-file=STR \t Say text from a file instead of info
    -m, --margin=INT \t\t Spaces on the left side of info
    -g, --gap=INT \t\t Spaces between info and info_value
    -l, --length=INT \t\t Length of the board ( > 14)
    -h, --help \t\t\t Print this help message\n\n};
    $help_text .= "available colors:\n    " . join(", ", splice(@colors, 0, 8));
    $help_text .= "\n    " . join(", ", @colors) . ", random\n";
    print $help_text;
}

main();
