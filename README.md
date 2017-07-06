<!---
IMPORTANT
=========
This README.md is displayed in the WebStore as well as within Jarvis app
Please do not change the structure of this file
Fill-in Description, Usage & Author sections
Make sure to rename the [en] folder into the language code your plugin is written in (ex: fr, es, de, it...)
For multi-language plugin:
- clone the language directory and translate commands/functions.sh
- optionally write the Description / Usage sections in several languages
-->
## Tuto pour pouvoir utilisé mpack
Il faut configurer le fichier ssmtp.conf:
`nano /etc/ssmpt/ssmtp.conf`
Puis le configurer en ajoutant c'est quelques lignes avec vos infos (là c'est pour gmail):
root=adresse@gmail.com
mailhub=smtp.gmail.com:587
hostname=raspberry
AuthUser=adresse@gmail.com
AuthPass=MotDePasseGmail
FromLineOverride=YES
UseSTARTTLS=YES
Puis sauvegarder : Ctrl+X puis O pour oui et entrer


## Description
Gestion de la liste des courses avec rappel si oublie.

## Usage
```
You: Ajoute du pain à la liste des courses
Jarvis: J'ai ajouté du pain à la liste

You: Ajoute 350 grammes de céléri à la liste des courses
Jarvis: J'ai ajouté 350 grammes de céléri  à la liste

You: Supprime toute la liste des courses
Jarvis: êtes vous sûr de vouloir supprimer les 2 ingréients de la listes des courses ?
You: Oui
Jarvis: Ok, la liste des courses a été effacée...
ou
You: Non
Jarvis: Ok je laisse...

You: Lis la liste des courses
Jarvis: voici les 2 ingrédients:
Jarvis: du pain, 350 grammes de céléri

You: Envoi moi la liste des courses par email
Jarvis: La liste des courses a été envoyer à VOTREPRENOM

You: Envoi la liste des courses par sms
Jarvis: A qui j'envoie la liste JB, Léa ou personne ?

Si le nombre de jour inscrit dans la variable $RAPPEL_FAIRE_COURSES du ficghier config.sh est déppasé il y a un rappel par jour quand il reçoit l'ordre du trigger...
Jarvis: Hé !? ça fait 12 jours que tu n'aurais pas fait les courses... !?
Jarvis:Pense à supprimer la liste c'est tu l'as fait depuis...

```

## Author
[tchoul] et [godinperson] et [JB] (https://github.com/Jean-Bernard-Hallez/jarvis-liste-des-courses1)