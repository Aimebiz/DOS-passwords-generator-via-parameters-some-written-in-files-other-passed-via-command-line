32 126		95 WPA2 permitted characters

passphrase of 8 to 63 printable ASCII characters


command model:		prog 0000 09 y y


recupere en parametre dans l'ordre
...tout simplement le caractere r pour continuer un processus mis en pause
signaler une erreur lorsque les parametres de reprise sont en defaut

...le type d'alphabet a utiliser sous forme de nombre binaire a quatre chiffres dont chacun prend la valeur 0 ou 1 validant respectivement majuscules minuscules chiffres autres_caracteres

...la longueur desiree pour les mots en 2 chiffres decimaux,y/n pour valider un fichier texte ndesired.txt contenant par ligne des caracteres non souhaitees a l'interieur des mots separees ou non par une tabulation horizontale les uns des autres et suivit d'au moins deux tabulations horizontales puis d'un chiffre indicant la position non souhaitee a l'interieur des mots, y/n pour valider un fichier texte imprtive.txt des caracteres imperatifs aux emplacement imperatifs a l'interieur des mots chaque caractere separe de sa position par une tabulation horizontale le tout suivit d'un retour a la ligne sauf pour le dernier

...le programme prend automatiquement en compte s'il existe dans son dossier un fichier ncombine.txt specifiant des combinaisons de 2 caracteres ne devant pas apparaitre a l'interieur des mots separes les uns des autres par deux caracteres quelconques ou tout simplement un retour automatique a la ligne

...le programme prend automatiquement en compte s'il existe dans son dossier un fichier avoid.txt specifiant des caracteres ne devant pas du tout apparaitre a l'interieur des mots separes par un seul espace ou un seul caractere quelconque a l'exception d'un retour a la ligne

...le programme prend automatiquement en compte s'il existe dans son dossier chacun des quatre fichiers nommes n3comb1.txt n3comb2.txt n3comb3.txt n3comb4.txt permettant d'autoriser jusqu'a 4 combinaisons de 3 consonnes ou de 3 voyelles commencant chacun par les memes combinaisons de deux consonnes ou de deux voyelles pour chaque double combinaisons de consonnes ou de voyelles le tout a conditions que le meme doublet commencant le triplet de caracteres WPA2 soit repartis dans les quatres fichiers sinon chaque seconde instance du triplet ecrase sa precedente instance

en example on pourrait repartir dans les quatres fichiers les triplets: ccr ccl... ou encore aia aie aio...

toute fois on peut se limiter a n'importe quel nombre de repartition en dessous de quatre

dans le cas ou on desire que le programme autorise tous les triplets de consonnes il suffit qu'aucun des quatres fichiers precites ne soit present dans son dossier ou qu'il soient tous vides

toutefois tous les quatres fichiers precites ne sont pas obliges d'etre tous present a la fois dans le dossier du programme


pause quand l'utilisateur entre le caractere q tout en demandant une confirmation et en se rappelant de sauver le fichier modifie ainsi que les parametres qui serviront a poursuivre la generation dans un fichier nomme param.txt