

Procedure UpdateStatusBar()
  ;StatusBarText(#StatusBar, 0, "Area 1")
  If DataBase_GetOneRow(#DataBase, "SELECT COUNT(*) as nb FROM film")
    film = GetNumField("nb")
    If film > 1
      StatusBarText(#StatusBar, 0, Str(film)+" films trouvés")
    Else
      StatusBarText(#StatusBar, 0, Str(film)+" film trouvé")
    EndIf
  Else
    StatusBarText(#StatusBar, 0, "")
  EndIf
EndProcedure


Procedure UpdateSearchFilm()
  ClearGadgetItemList(#Listview_Search)
  ClearList(ListIndexFilm())
  
  If GetGadgetState(#Combo_Acteur) > 0
    tableSup$ = ", joue, acteur"
  Else
    tableSup$ = ""
  EndIf
  
  query$ = "SELECT DISTINCT(numFilm), nomFilm, sousnomFilm FROM film, format, genre"
  query$ +tableSup$+" WHERE genreFilm=numGenre And formatFilm=numFormat"
  If Trim(GetGadgetText(#String_Search)) <> #NULL$
    s$ = ReplaceString(Trim(GetGadgetText(#String_Search)), "  ", " ")
    For i = 1 To CountString(s$, " ")+1
      s2$ = ForUpdate(StringField(s$, i, " "))
      query$ + " AND ( INSTR(nomFilm, "+s2$+") OR INSTR(sousnomFilm, "+s2$+") )"
    Next i
  EndIf
  
  If GetGadgetState(#Combo_Acteur) > 0
    query$ + " AND film=numFilm AND acteur=numActeur AND nomActeur="+ForUpdate(GetGadgetText(#Combo_Acteur))
  EndIf
  
  If GetGadgetState(#Combo_Genre) > 0
    query$ + " AND nomGenre="+ForUpdate(GetGadgetText(#Combo_Genre))
  EndIf
  
  If GetGadgetState(#Combo_Format) > 0
    query$ + " AND nomFormat="+ForUpdate(GetGadgetText(#Combo_Format))
  EndIf
  
  If GetGadgetState(#Combo_Date1) > 0
    query$ + " AND anneeFilm>="+GetGadgetText(#Combo_Date1)
  EndIf
  
  If GetGadgetState(#Combo_Date2) > 0
    query$ + " AND anneeFilm<="+GetGadgetText(#Combo_Date2)
  EndIf
  
  ;Debug query$
  If DatabaseQuery(#Database, query$+" ORDER BY nomFilm")
    While NextDatabaseRow(#Database)
      part1$ = GetStrField("nomFilm")
      part2$ = GetStrField("sousnomFilm")
      If part2$
        part2$ = " - " + part2$
      EndIf
      AddGadgetItem(#Listview_Search, -1, part1$+part2$)
      AddElement(ListIndexFilm())
        ListIndexFilm() = GetNumField("numFilm")
    Wend
  Else
    Debug "Err : "+query$
  EndIf
  UpdateSeeEditDropFilmButton()
  UpdateStatusBar()
EndProcedure



Macro VerifyMovieFields()
  If GetGadgetText(#StringAdd_NomFilm) = #NULL$
    Warning("Vous devez donner un nom à ce film !")
    SetActiveGadget(#StringAdd_NomFilm)
    ProcedureReturn #False
  ElseIf GetGadgetState(#ComboAdd_Genre) = -1
    Warning("Vous devez sélectionner une catégorie !")
    SetActiveGadget(#ComboAdd_Genre)
    ProcedureReturn #False
  ElseIf Not(IsNumeric(GetGadgetText(#StringAdd_Duree)))
    Warning("La durée est incorrecte !")
    SetActiveGadget(#StringAdd_Duree)
    ProcedureReturn #False
  ElseIf Not(IsNumeric(GetGadgetText(#StringAdd_Annee)))
    Warning("L'année de diffusion est incorrecte !")
    SetActiveGadget(#StringAdd_Annee)
    ProcedureReturn #False
  ElseIf GetGadgetState(#ComboAdd_Format) = -1
    Warning("Vous devez sélectionner un format !")
    SetActiveGadget(#ComboAdd_Format)
    ProcedureReturn #False
  EndIf
EndMacro


Procedure.s GetImageNameAndCopy(image$)
  If Len(image$) < 3
    image$ = "NULL"
  Else
    If FindString(image$, "\",1)
      CopyFile(image$, #Folder_Affiche+GetFilePart(image$))
      image$ = ForUpdate(GetFilePart(image$))
    Else
      image$ = forupdate(image$)
    EndIf
  EndIf
  ProcedureReturn image$
EndProcedure



Procedure ValidateAddMovie()
 ; Controle des valeurs saisies
  VerifyMovieFields()
  
  
 ; Préparation de la requete : récupération des valeurs
  indexGenre = GetIndexRow("genre", GetGadgetText(#ComboAdd_Genre), "nomGenre", "numGenre")
  indexFormat = GetIndexRow("format", GetGadgetText(#ComboAdd_Format), "nomFormat", "numFormat")
  duree = Val(GetGadgetText(#StringAdd_Duree))
  annee = Val(GetGadgetText(#StringAdd_Annee))
  image$ = GetGadgetText(#StringAdd_Image)
  ;If Len(image$) < 3
  ;  image$ = "NULL"
  ;Else
  ;  image$ = ForUpdate(images$)
  ;EndIf
  image$ = GetImageNameAndCopy(image$)
  
 ; Requete d'ajout
  query$ = "INSERT INTO film (nomFilm, sousnomFilm, genreFilm, dureeFilm, formatFilm, imageFilm, "
  query$ + "synopsisFilm, anneeFilm) VALUES("+NormalizedGadgetText(#StringAdd_NomFilm)+","
  query$ + NormalizedGadgetText(#StringAdd_SousTitre)+","+ForUpdate(Str(indexGenre))+","
  query$ + ForUpdate(Str(duree))+","+ForUpdate(Str(indexFormat))+","+image$+","
  query$ + NormalizedGadgetText(#EditorAdd_Synopsis)+","+ForUpdate(Str(annee))+")"
  If Not(DatabaseQuery(#Database, query$))
    Debug "Err : " + query$
    ProcedureReturn #False
  EndIf
  
 ; Gestion des acteurs
  indexFilm = GetMaxTable("film", "numFilm")
  ForEach ListIndexActorOfFilm()
    indexActeur = ListIndexActorOfFilm()
    If indexActeur
      If Not(DatabaseQuery(#Database, "INSERT INTO joue(acteur, film) VALUES("+Str(indexActeur)+", "+Str(indexFilm)+")"))
        Debug "Err: INSERT INTO joue"
      EndIf
    Else
      Debug "Err: Recup num acteur"
    EndIf 
  Next
  
 ; fermeture de la fenetre
  CancelAddMovie()
  UpdateSearchFilm()
  
  ProcedureReturn #True
EndProcedure



Procedure ValidateEditMovie()
 ; Controle des valeurs saisies
  VerifyMovieFields()
  
  
 ; Préparation de la requete : récupération des valeurs
  indexGenre = GetIndexRow("genre", GetGadgetText(#ComboAdd_Genre), "nomGenre", "numGenre")
  indexFormat = GetIndexRow("format", GetGadgetText(#ComboAdd_Format), "nomFormat", "numFormat")
  duree = Val(GetGadgetText(#StringAdd_Duree))
  annee = Val(GetGadgetText(#StringAdd_Annee))
  image$ = GetGadgetText(#StringAdd_Image)
  ;If Len(image$) < 3
  ;  image$ = "NULL"
  ;Else
  ;  image$ = ForUpdate(image$)
  ;EndIf
  image$ = GetImageNameAndCopy(image$)
    
 ; Requete d'ajout
  query$ = "UPDATE film SET nomFilm="+NormalizedGadgetText(#StringAdd_NomFilm)+", sousnomFilm="
  query$ + NormalizedGadgetText(#StringAdd_SousTitre)+", genreFilm="+ForUpdate(Str(indexGenre))
  query$ + ", dureeFilm="+ForUpdate(Str(duree))+", formatFilm="+ForUpdate(Str(indexFormat))
  query$ + ", imageFilm="+image$+", synopsisFilm="+NormalizedGadgetText(#EditorAdd_Synopsis)
  query$ + ", anneeFilm="+ForUpdate(Str(annee))+" WHERE numFilm="+Str(EditedFilm)
  If Not(DatabaseQuery(#Database, query$))
    Debug "Err : " + query$
    ProcedureReturn #False
  EndIf
  

  ; Supprime les anciens acteurs
  DatabaseQuery(#Database, "DELETE FROM joue WHERE film="+Str(EditedFilm))
  
 ; Gestion des acteurs
  ForEach ListIndexActorOfFilm()
    indexActeur = ListIndexActorOfFilm()
    If indexActeur
      If Not(DatabaseQuery(#Database, "INSERT INTO joue(acteur, film) VALUES("+Str(indexActeur)+", "+Str(EditedFilm)+")"))
        Debug "Err: INSERT INTO joue"
      EndIf
    Else
      Debug "Err: Recup num acteur"
    EndIf 
  Next
  
 ; fermeture de la fenetre
  CancelAddMovie()
  UpdateSearchFilm()
  
  ProcedureReturn #True
EndProcedure





Procedure UpdateSearchActor()
  ClearGadgetItemList(#Listview_Acteur)
  ClearList(ListIndexActor())
  DisableGadget(#Button_ActorOk, #True)
  
  query$ = "SELECT * FROM acteur WHERE 1"
  If Trim(GetGadgetText(#String_Acteur)) <> #NULL$
    s$ = ReplaceString(Trim(GetGadgetText(#String_Acteur)), "  ", " ")
    For i = 1 To CountString(s$, " ")+1
      s2$ = ForUpdate(StringField(s$, i, " "))
      query$ + " AND INSTR(nomActeur, "+s2$+")"
    Next i
  EndIf
  
  If DatabaseQuery(#Database, query$+" ORDER BY nomActeur")
    While NextDatabaseRow(#Database)
      AddGadgetItem(#Listview_Acteur, -1, GetStrField("nomActeur"))
      AddElement(ListIndexActor())
        ListIndexActor() = GetNumField("numActeur")
    Wend
  Else
    Debug "Err : "+query$
  EndIf
EndProcedure




Procedure AddFormat()
  format$ = AddNewFormat()
  If format$ <> #NULL$
    FillComboWithSupport(#Combo_Format, #Size_Combo_Format, #True)
    If IsWindowVisible_(WindowID(#Window_AddMovie))
      FillComboWithSupport(#ComboAdd_Format, #Size_Combo_Format)
      SetComboText(#ComboAdd_Format, format$)
    EndIf
    ProcedureReturn #True
  EndIf
EndProcedure


Procedure AddGenre()
  genre$ = AddNewGenre()
  If genre$ <> #NULL$
    FillComboWithGenre(#Combo_Genre, #Size_Combo_Genre, #True)
    If IsWindowVisible_(WindowID(#Window_AddMovie))
      FillComboWithGenre(#ComboAdd_Genre, #Size_Combo_Genre)
      SetComboText(#ComboAdd_Genre, genre$)
    EndIf
    ProcedureReturn #True
  EndIf
EndProcedure



Procedure AddActeur()
  acteur$ = AddNewActeur()
  If acteur$ <> #NULL$
    FillComboWithActeur(#Combo_Acteur, #Size_Combo_Acteur, #True)
    If IsWindowVisible_(WindowID(#Window_AddMovie))
      ReplaceString(acteur$, ";", ",", 2)
      For i = 1 To CountString(acteur$, ",")+1
        AddActorOfFilmToList2(StringField(acteur$, i, ","))
      Next i
    EndIf
    ProcedureReturn #True
  EndIf
EndProcedure



Procedure.s EditConfiguration(texte$)
  retour$ = InputRequester2(#Project_Name, "Modification :", texte$)
  If retour$ And retour$ <> texte$
    query$ = "UPDATE "+Config\nomTable+" SET "+Config\strField+"="+ForUpdate(retour$)
    query$ + " WHERE "+Config\strField+"="+ForUpdate(texte$)
    If DatabaseQuery(#Database, query$)
      ProcedureReturn retour$
    Else
      Warning("Le genre existe déjà !")
    EndIf
  EndIf
  ProcedureReturn #NULL$
EndProcedure


Procedure DropConfiguration(texte$)
  index = GetIndexRow(Config\nomTable, texte$, Config\strField, Config\numField)
  If index
    query$ = "SELECT * FROM "+Config\fldTable+" WHERE "+Config\fieldFilm+"="+Str(index)
    If DataBase_GetOneRow(#Database, query$)
      warning = #True
      If Config\nomTable = "acteur"
        msg$ = "Cet acteur sera retiré des films dans lequel il joue."
      Else
        msg$ = "Les films contenant "+Config\preposition+" "+Config\nomTable+"seront supprimés."
      EndIf
      msg$ + Chr(13)+Chr(10)+"Confirmer la suppression ?"
    Else
      warning = #False
      msg$ = "Supprimer "+Config\preposition+" "+Config\nomTable+" ?"
    EndIf
    If MessageRequester(#Project_Name, msg$, #PB_MessageRequester_YesNo | #MB_ICONWARNING) = 6
      If warning
        If Config\nomTable <> "acteur"
           DeleteImageFilm(Config\fieldFilm+"="+Str(index))
        EndIf
        query$ = "DELETE FROM "+Config\fldTable+" WHERE "+Config\fieldFilm+"="+Str(index)
        DatabaseQuery(#Database, query$)
      EndIf
      query$ = "DELETE FROM "+Config\nomTable+" WHERE "+Config\numField+"="+Str(index)
      If DatabaseQuery(#Database, query$)
        ProcedureReturn #True
      Else
        Alert("Erreur lors de la suppression d'1 "+Config\nomTable)
      EndIf
    EndIf
  EndIf
  ProcedureReturn #False
EndProcedure



Macro DropMovie()
  index = GetGadgetState(#Listview_Search)
  If index > -1
    input = MessageRequester("Suppression d'un film", "Etes-vous sûr de vouloir supprimer le film sélectionné ?", #MB_ICONWARNING | #PB_MessageRequester_YesNo)
    If input = 6
      SelectElement(ListIndexFilm(), index)
      DeleteImageFilm(" numFilm="+Str(ListIndexFilm()))
      query$ = "DELETE FROM film WHERE numFilm="+Str(ListIndexFilm())
      If DatabaseQuery(#Database, query$)
        DatabaseQuery(#Database, "DELETE FROM joue WHERE film="+Str(ListIndexFilm()))
        DeleteElement(ListIndexFilm())
        RemoveGadgetItem(#Listview_Search, index)
        UpdateStatusBar()
        UpdateSeeEditDropFilmButton()
      Else
        Debug "Err : " + query$
      EndIf
    EndIf
  EndIf
EndMacro



Macro ActualiseMainWindowAfterConfiguration()
  ActualiseListViewWithConfig()
  Select Config\nomTable
    Case "genre"
      FillComboWithGenre(#Combo_Genre,    #Size_Combo_Genre,  #True)
    Case "acteur"
      FillComboWithActeur(#Combo_Acteur,  #Size_Combo_Acteur, #True)
    Case "format"
      FillComboWithSupport(#Combo_Format, #Size_Combo_Format, #True)
  EndSelect
  UpdateSearchFilm()
EndMacro







; +--------------------------------------------------------+
; |                  Window Callback                       |
; +--------------------------------------------------------+


Procedure ProgramCallback(WindowID, Message, wParam, lParam)
  ;Debug Message
  If Message = #PB_Event_CloseWindow   
    Select WindowID
      
      Case WindowID(#Window_Main)
        QuitProgram()
      
      Case WindowID(#Window_AddMovie)
        CancelAddMovie()
    
      Case WindowID(#Window_Actor)
        CancelSearchForActor()
    
      Case WindowID(#Window_Configuration)
        CancelConfigurate()
      
      Case WindowID(#Window_SeeFilm)
        CloseSeeMovieWindow()
    
    EndSelect
  ElseIf (Message = 256 Or Message = 261 Or Message = 257) And wParam = 27
    Select WindowID
      Case WindowID(#Window_Configuration)
        CancelConfigurate()
      Case WindowID(#Window_AddMovie)
        CancelAddMovie()
      Case WindowID(#Window_Actor)
        CancelSearchForActor()
      Case WindowID(#Window_SeeFilm)
        CloseSeeMovieWindow()
    EndSelect
  EndIf

  ;Debug "-=-=-"
  ;Debug Message
  ;Debug wParam
  ;Debug lParam

  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure



; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 290
; FirstLine = 260
; Folding = ---
; EnableAsm
; EnableThread
