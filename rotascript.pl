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
# nettoyage des fichiers temporaires
	clear_temp();
	


}




sub presentation {
	print "\n   |--------------------|\n";
	print "   |     Rotascript     |\n";
	print "   |--------------------|\n\n\n";
}

sub load_param {
	print "-> Chargement des paramètres sélectionnés\n";
#	TODO ajouter le traitement des paramètres par flag
	print "-> PARAMÈTRES PAR DÉFAUT\n";
	$separatorIn = ',';
	$separatorOut = ' ';
	$separatorDecIn = ',';
	$separatorDecOut = '.';
	$nbFiles = 0;
	my $tempName =$input;
	$tempName =~ s/.csv//g;
	$filename = "$tempName-reversed.dat";
	print "-> Fin de chargement des paramètres\n";
        print "-----------------------------\n";
}

sub load_table { 
	print "-> Chargement de la table $_[0]\n";
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
        print "-> Fin de chargement de la table\n";
        print "-----------------------------\n";

}

sub Temp {
	#        print @_; 
        open(my $FH, '>>', "./$_[1].temp") or die "Impossible d'ouvir le fichier temporaire\n";
        print $FH $_[0];
        close $FH;

}

sub verif_input{
	if(1!=1){
		die "1!=1";
		#C'est rigolo de faire des vérifications inutiles en attendant l'implémentation des vrais vérifications
	}
}

sub build_table{
	print "-> Début de la construction de la table\n";
	open(my $WR, '>>', "./$filename") or die "Impossible d'ouvir le fichier d'impression\n";
	for my $i (0 .. $nbFiles-1){
		open(my $RD, '<', "./ligne$i.temp") or die "Impossible d'ouvrir le fichier temporaire ligne$i.temp\n";
		while (my $line = <$RD>) {
			chomp $line;
			print $WR "$line\n";
		}
		close $RD;
	}
	close $WR;
	print "-> Table $filename construite\n";
        print "-----------------------------\n";

}

sub clear_temp{
	for my $i (0 .. $nbFiles-1){
		unlink "./ligne$i.temp" or die "Impossible de supprimer le fichier temporaire ligne$i.temp\n";
	}
}	







