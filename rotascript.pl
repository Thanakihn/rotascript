#!/usr/bin/perl
# Script de renversement d'une table spice

use strict;
use warnings;

# Possibilité de définir des flags... bon, on verra ça après
# use Getopt::Long;

#Définition des variables
my $separatorIn;
my $separatorOut;
my $separatorDecIn;
my $separatorDecOut;
my $fileIn;
my $nbFiles;
my @table;
#Nom du fichier en sortie
my $filename;

my $input=$ARGV[0];
print "$input";


main();


sub main {
# Fichier de présentation
	presentation();

# Vérification des input
# TODO 
	verif_input($input);
# Gestion des flags
# TODO
	load_param();

# Pour renverser la table, on lit chaque ligne et chaque colonne est placée dans un fichier temporaire
	load_table($input);
# puis les fichiers sont réassemblés
	build_table();
# exportation de la nouvelle table
	


}




sub presentation {
	print "|--------------------|\n";
	print "|     Rotascript     |\n";
	print "|--------------------|\n";
}

sub load_param {
	$separatorIn = ',';
	$separatorOut = ' ';
	$separatorDecIn = ',';
	$separatorDecOut = '.';
	$nbFiles = 0;
	$filename = "NomDeDebug.csv";
}

sub load_table { 
	print "loading table $_[0]\n";
	my $file = $_[0];
	open(my $data, '<', $file) or die "Impossible d'ouvrir le fichier '$file'\n";
	while (my $line = <$data>) {
 		chomp $line;
		my @fields = split ";" , $line;
		#Compter le nombre de fichiers temporaires construits
		if( $#fields+1>=$nbFiles ){
			$nbFiles = $#fields+1;
		}
		#Construire fichiers temporaires
		for my $i (0 .. $#fields){
			my $varCleaned = $fields[$i];
		       $varCleaned =~ s/$separatorDecIn/$separatorDecOut/g;
			Temp("$varCleaned$separatorOut","ligne$i");
		}
	}
	close $data;
}

sub Temp {
        print @_; 
        open(my $FH, '>>', "./$_[1].temp") or die "Impossible d'ouvir le fichier temporaire";
        print $FH $_[0];
        close $FH;

}

sub verif_input{
	if(1!=1){
		die "1!=1";
	}
}

sub build_table{
	open(my $WR, '>>', "./$filename") or die "Impossible d'ouvir le fichier d'impression";
	for my $i (0 .. $nbFiles-1){
		open(my $RD, '<', "./ligne$i.temp") or die "Impossible d'ouvrir le fichier temporaire ligne$i.temp";
		while (my $line = <$RD>) {
			chomp $line;
			print $WR "$line\n";
		}
		close $RD;
	}
	close $WR;
}









