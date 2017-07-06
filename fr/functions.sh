#!/bin/bash
# Here you can define translations to be used in the plugin functions file
# the below code is an sample to be reused:
# 1) uncomment to function below
# 2) replace XXX by your plugin name (short)
# 3) remove and add your own translations
# 4) you can the arguments $2, $3 passed to this function
# 5) in your plugin functions.sh file, use it like this:
#      say "$(pv_myplugin_lang the_answer_is "oui")"
#      => Jarvis: La réponse est oui

#pv_XXX_lang () {
#    case "$1" in
#        i_check) echo "Je regarde...";;
#        the_answer_is) echo "La réponse est $2";;
#    esac
#} 

jv_pg_ct_ajoute_course () {
jv_pg_ct_testjour_course
ajoutecaourse=$(cat ~/liste.txt | sed -e 's/ajoute //g' | sed -e 's/à la liste//g' | sed -e 's/des courses//g' | sed -e 's/courses//g' | sed -e 's/  / /g');
# echo "-----$ajoutecaourse-----"
echo "$ajoutecaourse" >> ~/listedescourses.txt;
say "J'ai ajouté $ajoutecaourse à la liste";
sudo rm ~/liste.txt
}

jv_pg_ct_supprime_coursetout() {
if test -e /home/pi/listedescourses.txt; then
listecontien="$(cat ~/listedescourses.txt | uniq | paste -s -d ',' | sed -e 's/,/, /g')" ;
listecontien_total=`echo $listecontien | grep -o "," | wc -w`;
listecontien_total=$(( $listecontien_total + 1 ));
	if [[ "$listecontien_total" -gt "1" ]]; then
	say "êtes vous sûr de vouloir supprimer les $listecontien_total ingréients de la listes des courses ?";
	else
	say "êtes vous sûr de vouloir supprimer la listes des courses, il y a 1 ingrédient ?";
	fi
else
say "Il n'y a atuellement aucune liste de course...";
GOTOSORTICOURSE="Fin"; 
fi
}

jv_pg_ct_supprime_coursetout1() {
sudo rm /home/pi/listedescourses.txt;
if test -e /home/pi/listedescourses_dit.txt; then
sudo rm /home/pi/listedescourses_dit.txt
fi
say "Ok, la liste des courses a été effacée...";
}


jv_pg_ct_supprime_course () {
if [[ "$order" =~ "dernie" ]]; then
lirederliste="$(cat /home/pi/listedescourses.txt | tail -1)";
say "$lirederliste est supprimé de la liste";
sed -i -e  "/$lirederliste/d" /home/pi/listedescourses.txt;
return;
fi

efface="$(cat ~/liste.txt | sed -e 's/ a//g')";

listecontien_efface=`grep -o "$efface" /home/pi/listedescourses.txt | wc -w`;
if [[ "$listecontien_efface" == "1" ]]; then
sed -i -e  "/$efface/d" /home/pi/listedescourses.txt;
jv_pg_ct_supprime_course_ok;
return;
fi

efface1=`echo $efface | sed 's/.* //'`
listecontien_efface=`grep -o "$efface1" /home/pi/listedescourses.txt | wc -w`;
if [[ "$listecontien_efface" == "1" ]]; then
sed -i -e  "/$efface1/d" /home/pi/listedescourses.txt;
jv_pg_ct_supprime_course_ok;
return;
fi

efface1=`echo $efface | awk '{print $(NF-1)}'`
listecontien_efface=`grep -o "$efface1" /home/pi/listedescourses.txt | wc -w`;
if [[ "$listecontien_efface" == "1" ]]; then
sed -i -e  "/$efface1/d" /home/pi/listedescourses.txt;
jv_pg_ct_supprime_course_ok
return;
fi

say "désolé je ne trouve pas l'ingrédient $efface1 à supprimer"
}

jv_pg_ct_supprime_course_ok () {
efface="$(cat ~/liste.txt | sed -e 's/ a//g')";
say "$efface est supprimé de la liste des courses";
sudo rm ~/liste.txt;
}


jv_pg_ct_lis_course () {
jv_pg_ct_testjour_course
if test -e /home/pi/listedescourses.txt; then
listecontien="$(cat ~/listedescourses.txt | uniq | paste -s -d ',' | sed -e 's/,/, /g')" ;
listecontien_total=`echo $listecontien | grep -o "," | wc -w`;
listecontien_total=$(( $listecontien_total + 1 ));
	if [[ "$listecontien_total" -gt "1" ]]; then
	say "voici les $listecontien_total ingrédients:";
	else
	say "il n'y a que 1 ingrédient:";
	fi
say "$listecontien";
else
say "la liste des courses est vide..."
fi
}

jv_pg_ct_envoi_course () {
mpack -s "Contenu de la liste des courses" /home/pi/listedescourses.txt VOTREMAIL@hotmail.com && say "La liste des courses a été envoyer à VOTREPRENOM";
}

jv_pg_ct_testjour_course () {
Jour_course_aujourdhui=`date +%d`;
if test -e /home/pi/listedescourses.txt; then
	Jour_course_enregis=`date -r ~/listedescourses.txt | cut -d" " -f2`;
	Jour_course_enregis_entiere=`date -r ~/listedescourses.txt | cut -d" " -f1-3`;
	if [[ "$Jour_course_aujourdhui" =~ "$Jour_course_enregis" ]]; then
	return;
	else
	jv_pg_ct_testjour_course1;
	fi
fi
}

jv_pg_ct_testjour_course1_email () {
say "Avez vous fait vos courses ? car depuis le $Jour_course_enregis_entiere:"
}

jv_pg_ct_envoi_course_sms () {
if test -e /home/pi/listedescourses.txt; then
	if jv_plugin_is_enabled "jarvis-FREE-sms"; then
	say "Est-ce que je vous envoie la liste des courses par sms à $(jv_pg_ct_ilyanom) ou personne ?";
	else
	say "vous n'avez pas le plugin jarvis free sms pour faire cela... annulation";
	GOTOSORTICOURSE="Fin";
	return;
	fi
else
say "vous n'avez pas d'ingrédient à envoyer par sms... annulation";
GOTOSORTICOURSE="Fin";
return;
fi

}

jv_pg_ct_envoi_course_sms1 () {
if jv_plugin_is_enabled "jarvis-FREE-sms"; then

	if [[ "$order" =~ "personn" ]]; then
	say "Ok, annulation...";
	return; 
	fi	
	
	jv_pg_ct_verinoms;
	if [[ "$PNOM" == "" ]]; then
	return;
	fi

	say "Voilà je fais partir la liste par sms à $PNOM."
	commands="$(jv_get_commands)"
	listecourseacheter=`echo "Liste d'ingrédients à acheter: $(cat /home/pi/listedescourses.txt)" | paste -s -d "," | sed -e 's/,/, /g'`
#	echo "$listecourseacheter";
	jv_handle_order "MESSEXTERNE ; $PNOM ; $listecourseacheter";
else
say "vous n'avez pas le plugin jarvis free sms pour faire cela... annulation";
GOTOSORTICOURSE="Fin"; 
return;
fi
}

jv_pg_ct_datefaire_course () {

if test -e /home/pi/listedescourses.txt; then
Jour_course_enregis_diff=`echo $((($(date +%s)-$(date -r ~/listedescourses.txt +%s))/86400))`

	if [[ "$Jour_course_enregis_diff" -ge "$RAPPEL_FAIRE_COURSES" ]]; then

		if [ ! -e ~/listedescourses_dit.txt ]; then 
		date +%D > ~/listedescourses_dit.txt; 
		jv_pg_ct_datefaire_course1;
		return;
		fi

		if [[ $(cat ~/listedescourses_dit.txt) != `date +%D` ]]; then	
		jv_pg_ct_datefaire_course1
		date +%D > "~/listedescourses_dit.txt"
		fi
	fi
else
	if test -e /home/pi/listedescourses_dit; then
	sudo rm /home/pi/listedescourses_dit
	fi
fi
}

jv_pg_ct_datefaire_course1 () {
say "Hé !? ça fait $Jour_course_enregis_diff jours que tu n'aurais pas fait les courses... !?"
say "Pense à supprimer la liste c'est tu l'as fait depuis..."
}
	
	

