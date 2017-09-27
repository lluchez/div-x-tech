

Macro QuitProgram()
  ;Debug "Close"
  BD_Close()
  End
EndMacro




Macro CancelAddMovie()
  DisableWindow(#Window_Main, #False)
  HideWindow(#Window_AddMovie, #True)
  SetActiveWindow(#Window_Main)
EndMacro


Macro CancelSearchForActor()
  SetGadgetState(#Listview_Acteur,-1)
  DisableWindow(#Window_AddMovie, #False)
  HideWindow(#Window_Actor, #True)
  SetActiveWindow(#Window_AddMovie)
EndMacro


Procedure ShowMainWindow()
  HideWindow(#Window_Main, #False)
  FillMainWindowWithBD()
  SetActiveGadget(#StringAdd_NomFilm)
EndProcedure




Macro OpenAddMovieWindow()
 ; MaJ des StringGadgets et ComboGadgets  
  SetGadgetText(#StringAdd_NomFilm, "")
  SetGadgetText(#StringAdd_SousTitre, "")
  SetGadgetText(#StringAdd_Duree, "")
  SetGadgetText(#Label_Duree, "")
  SetGadgetText(#StringAdd_Annee, "")
  SetGadgetText(#StringAdd_Image, "")
  SetGadgetText(#EditorAdd_Synopsis, "")
  DisableGadget(#ButtonAdd_DropAct, #True)
  ;SetGadgetText(#ButtonAdd_Add,     #Text_Add_Film)
  SetWindowTitle(#Window_AddMovie,  #Title_Add_Film)
  SetGadgetState(#ButtonAdd_Add, ImageRecord)
  
 ; MaJ des ComboGadgets et ListViewGadgets
  FillComboWithGenre(#ComboAdd_Genre,     #Size_Combo_Genre)
  FillComboWithSupport(#ComboAdd_Format,  #Size_Combo_Format)
  ClearGadgetItemList(#ListviewAdd_Acteur)
  ClearList(ListIndexActorOfFilm())

 ; MaJ des fenêtres
  DisableWindow(#Window_Main, #True)
  HideWindow(#Window_AddMovie, #False)
  
  ; Focus
  SetActiveGadget(#StringAdd_NomFilm)
  
EndMacro



Macro OpenEditMovieWindow()
  If GetGadgetState(#Listview_Search) > -1
    SelectElement(ListIndexFilm(), GetGadgetState(#Listview_Search))
    EditedFilm = ListIndexFilm()
    query$ = "SELECT * FROM film, format, genre WHERE genreFilm=numGenre AND formatFilm=numFormat AND numFilm="+Str(EditedFilm)
    If DataBase_GetOneRow(#Database, query$)
     ; MaJ des StringGadgets et ComboGadgets 
      SetGadgetText(#StringAdd_NomFilm,   GetStrField("nomFilm"))
      SetGadgetText(#StringAdd_SousTitre, GetStrField("sousnomFilm"))
      SetGadgetText(#StringAdd_Duree,     Str(GetNumField("dureeFilm")))
      SetGadgetText(#StringAdd_Annee,     Str(GetNumField("anneeFilm")))
      SetGadgetText(#StringAdd_Image,     GetStrField("imageFilm"))
      SetGadgetText(#EditorAdd_Synopsis,  GetStrField("synopsisFilm"))
      DisableGadget(#ButtonAdd_DropAct,   #True)
      ;SetGadgetText(#ButtonAdd_Add,       #Text_Edit_Film)
      SetWindowTitle(#Window_AddMovie,    #Title_Edit_Film)
      genre$  = GetStrField("nomGenre")
      format$ = GetStrField("nomFormat")
      SetGadgetState(#ButtonAdd_Add, ImageEditF)
      
     ; MaJ des ComboGadgets et ListViewGadgets
      FillComboWithGenre(#ComboAdd_Genre,   #Size_Combo_Genre)
      SetComboText(#ComboAdd_Genre, genre$)
      FillComboWithSupport(#ComboAdd_Format,#Size_Combo_Format)
      SetComboText(#ComboAdd_Format, format$)
      ClearGadgetItemList(#ListviewAdd_Acteur)
      ClearList(ListIndexActorOfFilm())
      
      
      If DatabaseQuery(#Database, "SELECT * FROM joue, acteur WHERE acteur=numActeur AND film="+Str(EditedFilm))
        While NextDatabaseRow(#Database)
          AddGadgetItem(#ListviewAdd_Acteur, -1, GetStrField("nomActeur"))
          AddElement(ListIndexActorOfFilm())
            ListIndexActorOfFilm() = GetNumField("numActeur")
        Wend
      EndIf
      
     ; MaJ des fenêtres
      DisableWindow(#Window_Main, #True)
      HideWindow(#Window_AddMovie, #False)
      
    EndIf
  EndIf
  
  ; Focus
  SetActiveGadget(#StringAdd_NomFilm)
EndMacro





Macro OpenActorWindow()
  SetGadgetText(#String_Acteur, "")
  DisableGadget(#Button_ActorOk, #True)
  ;FillActorWindowWithBD()
  UpdateSearchActor()

 ; MaJ des fenêtres
  DisableWindow(#Window_AddMovie, #True)
  HideWindow(#Window_Actor, #False)
  
  ; Focus
  SetActiveGadget(#String_Acteur)
EndMacro



Procedure AddActorOfFilmToList2(acteur$)
  If acteur$
    For i=0 To CountGadgetItems(#ListviewAdd_Acteur)-1
      If GetGadgetItemText(#ListviewAdd_Acteur,i,-1) = acteur$
        ProcedureReturn
      EndIf
    Next i
    If DataBase_GetOneRow(#DataBase, "SELECT numActeur FROM acteur WHERE nomACteur="+ForUpdate(acteur$))
      AddGadgetItem(#ListviewAdd_Acteur, -1, acteur$)
      AddElementAtEnd( ListIndexActorOfFilm(), GetNumField("numActeur") )
      ;SelectElement(ListIndexActor(), GetGadgetState(#Listview_Acteur))
      ;AddElement(ListIndexActorOfFilm())
      ;  ListIndexActorOfFilm() = ListIndexActor()
    EndIf
  EndIf
EndProcedure




Procedure AddActorOfFilmToList()
  If GetGadgetState(#Listview_Acteur) <> -1
    For i=0 To CountGadgetItems(#ListviewAdd_Acteur)-1
      If GetGadgetItemText(#ListviewAdd_Acteur,i,-1) = GetGadgetText(#Listview_Acteur)
        ProcedureReturn
      EndIf
    Next i
    AddGadgetItem(#ListviewAdd_Acteur, -1, GetGadgetText(#Listview_Acteur))
    SelectElement(ListIndexActor(), GetGadgetState(#Listview_Acteur))
    ;LastElement(ListIndexActorOfFilm())
    ;AddElement(ListIndexActorOfFilm())
    ;  ListIndexActorOfFilm() = ListIndexActor()
    AddElementAtEnd( ListIndexActorOfFilm(), ListIndexActor() )
  EndIf
EndProcedure




Macro SetCaptionWindowConfig(insert, edit, drop, title)
  GadgetToolTip(#Bt_Config_Add, insert)
  GadgetToolTip(#Bt_Config_Edit, edit)
  GadgetToolTip(#Bt_Config_Drop, drop)
  
  SetWindowTitle(#Window_Configuration, title)
  SetGadgetText(#Frame3D_Config, title)
EndMacro


Macro ActualiseListViewWithConfig()
  ClearGadgetItemList(#List_Config)
  DatabaseQuery(#DataBase, "SELECT * FROM "+Config\nomTable+" ORDER BY "+Config\strField)
  While NextDatabaseRow(#DataBase)
    AddGadgetItem(#List_Config, -1, GetStrField(Config\strField))
  Wend

  DisableGadget(#Bt_Config_Edit, #True)
  DisableGadget(#Bt_Config_Drop, #True)
EndMacro


Macro FillStructureConfiguration(table, num, string, table2, film, prepo)
  Config\nomTable   = table
  Config\strField   = string
  Config\numField   = num
  Config\fldTable   = table2
  Config\fieldFilm  = film
  Config\preposition  = prepo
  Config\exCurWindow  = GetActiveWindow()
EndMacro


Macro ShowConfigWindow()
  DisableWindow(Config\exCurWindow, #True)
  HideWindow(#Window_Configuration, #False)
EndMacro


Macro CancelConfigurate()
  DisableWindow(Config\exCurWindow, #False)
  HideWindow(#Window_Configuration, #True)
EndMacro




Macro ShowConfigActeurWindow()
  SetCaptionWindowConfig("Ajouter un acteur", "Modifier l'acteur courant", "Supprimer l'acteur courant", "Gestion des acteurs")
  FillStructureConfiguration("acteur", "numActeur", "nomActeur", "joue", "acteur", "cet")
  ActualiseListViewWithConfig()
  ShowConfigWindow()
EndMacro


Procedure ShowConfigGenreWindow()
  SetCaptionWindowConfig("Ajouter un genre", "Modifier le genre courant", "Supprimer le genre courant", "Gestion des genres")
  FillStructureConfiguration("genre", "numGenre", "nomGenre", "film", "genreFilm", "ce")
  ActualiseListViewWithConfig()
  ShowConfigWindow()
EndProcedure


Procedure ShowConfigFormatWindow()
  SetCaptionWindowConfig("Ajouter un format", "Modifier le format courant", "Supprimer le format courant", "Gestion des formats")
  FillStructureConfiguration("format", "numFormat", "nomFormat", "film", "formatFilm", "ce")
  ActualiseListViewWithConfig()
  ShowConfigWindow()
EndProcedure



Macro UpdateSeeEditDropFilmButton()
  If GetGadgetState(#Listview_Search) = -1
    etat = #True
  Else
    etat = #False
  EndIf
  DisableGadget(#Button_SeeMovie, etat)
  DisableGadget(#Button_EditMovie, etat)
  DisableGadget(#Button_DropMovie, etat)
  
  DisableMenuItem(#MenuBar, #MENU_SeeFilm, etat)
  DisableMenuItem(#MenuBar, #MENU_EditFilm, etat)
  DisableMenuItem(#MenuBar, #MENU_DropFilm, etat)
EndMacro



Macro UpdateSeeFilmWindowInformations2(titre, nom, sousTitre, genre, format, duree, annee, acteurs, image, synopsis)
  SetWindowTitle(#Window_SeeFilm, titre)
  SetGadgetText(#TextSee_NomFilm, nom)
  SetGadgetText(#TextSee_SousNomFilm, sousTitre)
  SetGadgetText(#TextSee_Acteurs, "Acteurs : "+acteurs)
  SetGadgetText(#TextSee_Genre, "Genre : "+genre)
  SetGadgetText(#TextSee_Format, "Format : "+format)
  SetGadgetText(#TextSee_Annee, "Annee : "+annee)
  SetGadgetText(#TextSee_Duree, "Durée : "+duree)
  SetGadgetText(#EditorSee_Synopsis, synopsis)
  If image <> #NULL$
    imageID = LoadImage(#PB_Any, #Folder_Affiche+image)
    If imageID
      SetGadgetState(#ImageSee_NomFilm, ImageID(imageID))
      FreeImage(imageID)
    Else
      SetGadgetState(#ImageSee_NomFilm, 0)
    EndIf
  Else
    SetGadgetState(#ImageSee_NomFilm, 0)
  EndIf
EndMacro



Procedure UpdateSeeFilmWindowInformations(index)
  DisableGadget(#BtImageSee_Prev, Inferieur(index, 1))
  DisableGadget(#BtImageSee_Next, Egal(index, CountGadgetItems(#Listview_Search)-1))
  SelectElement(ListIndexFilm(), index)
  If DataBase_GetOneRow(#DataBase, "SELECT * FROM film, genre, format WHERE genreFilm=numGenre AND formatFilm=numFormat AND numFilm="+Str(ListIndexFilm()))
    nom$ = GetStrField("nomFilm")
    titre$ = nom$
    snom$ = GetStrField("sousnomFilm")
    If snom$
      titre$ + " - " + snom$
    EndIf
    genre$ = GetStrField("nomGenre")
    format$ = GetStrField("nomFormat")
    duree$ = MinutesToString(GetNumField("dureeFilm"))
    annee$ = Str(GetNumField("anneeFilm"))
    image$ = GetStrField("imageFilm")
    synopsis$ = GetStrField("synopsisFilm")
    
    If DatabaseQuery(#DataBase, "SELECT nomActeur FROM joue, acteur WHERE numActeur=acteur AND film="+Str(ListIndexFilm()))
      NewList liste.s()
      While NextDatabaseRow(#DataBase)
        AddElement(liste())
          liste() = GetStrField("nomActeur")
          ;Debug liste()
      Wend
      acteurs$ = Implode(liste(), ", ")
      ClearList(liste())
      ;Debug acteurs$
    Else
      Debug "Err requete acteurs"
    EndIf
    UpdateSeeFilmWindowInformations2(titre$, nom$, snom$, genre$, format$, duree$, annee$, acteurs$, image$, synopsis$)
  Else
    UpdateSeeFilmWindowInformations2("Affichage d'un film", "", "", "", "", "", "", "", "", "")
    Debug "Err ds la requete"
  EndIf
EndProcedure


Macro OpenSeeMovieWindow()
  HideWindow(#Window_Main, #True)
  HideWindow(#Window_SeeFilm, #False)
  UpdateSeeFilmWindowInformations(GetGadgetState(#Listview_Search))
EndMacro


Macro CloseSeeMovieWindow()
  HideWindow(#Window_Main, #False)
  HideWindow(#Window_SeeFilm, #True)
EndMacro


; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 257
; FirstLine = 245
; Folding = ----
; EnableAsm
; EnableThread
