

; Liste globale pour stocker les numéro des films affichés lors d'une recherche
Global NewList ListIndexFilm.l()

; Liste globale pour stocker les numéro des acteurs affichés lors d'une recherche
Global NewList ListIndexActor.l()

; Liste globale pour stocker les numéro des acteurs pour l'ajout des acteurs à un film
Global NewList ListIndexActorOfFilm.l()



#Project_Name = "Div-X-Tech"
#PB_EventType_ComboChanged = #PB_EventType_RightClick


#Folder_Affiche = "Affiche/"

#ImageIndex_Affiche = 1000


; ---------------------------------------------------
; - Pour ajouter/modifier un film

Global EditedFilm.l

#Text_Edit_Film = "Modifier"
#Text_Add_Film  = "Ajouter"

#Title_Edit_Film  = "Modification d'un film"
#Title_Add_Film   = "Ajout d'un nouveau film"



; ---------------------------------------------------
; - Configuration Genre / Format / Acteur

Structure Configuration
  nomTable.s  ; genre
  strField.s  ; nomGenre
  numField.s  ; numGenre
  fldTable.s  ; film
  fieldFilm.s ; genreFilm
  preposition.s ; ce/cet
  exCurWindow.l ; Id de la Window active
EndStructure

Global Config.Configuration



; ---------------------------------------------------
; - Taille des ComboGadget Genre / Format / Acteur

#Size_Combo_Genre = 6
#Size_Combo_Format = 4
#Size_Combo_Acteur = 6
; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 19
; Folding = -
; EnableAsm
; EnableThread
