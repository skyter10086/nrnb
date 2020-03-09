#!/usr/bin/env raku

# nrnb.p6 --- A script of rename files of the directory batchly.
# Date: 2020-3-8
# Author: zby
#

use Text::CSV;

sub rename_files(IO::Path $path, @new_names) {
  
  unless ($path.d) {
    say 'The path param went WRONG!';
    exit;
  }
  
  #my @origin_files = $path.dir.grep(*.f);
  #my @old_names = @origin_files>>.Str.sort;
  my @old_names = $path.dir.grep(*.f)
                           .map(*.Str)
                           .sort;
  
  unless (@old_names.elems == @new_names.elems) {
    say 'The files count does not match the names count.';
    exit;
  }

  my Str $new_name;
  my Str $old_name;
  my Str $dir_name;

  for  0 .. @old_names.elems-1 -> $i {
    $old_name = @old_names[$i]; 
    $dir_name = @old_names[$i].IO.dirname;

    if @old_names[$i] ~~ rx/(\.\w+)/ {
      $new_name = $dir_name ~ '/' ~ @new_names[$i] ~ $0;  
    } else {
      $new_name = $dir_name ~ '/' ~ @new_names[$i];
    }
    
    rename($old_name, $new_name);
    say 'Rename [' ~ $old_name ~'] To [' ~ $new_name ~ '].';
  }
  say "Total " ~ @old_names.elems ~ " files done.";

}

sub MAIN(Str $path_name, Str $csv_name) {
  my @data = csv(in => $csv_name) or die "CSV file is not work.";
  my $path_ = $path_name.IO or die "The $path_name directory is not exist.";
  rename_files($path_, @data);
}
