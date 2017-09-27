

Procedure ResizeComboBox(id.l, max.l)
  nb.l = CountGadgetItems(id)+1
  If nb > max
    nb = max
  ElseIf nb = 0
    nb = 1
  EndIf
  ResizeGadget(id, #PB_Ignore, #PB_Ignore, #PB_Ignore, nb*20)
EndProcedure


Procedure IniCombo(gadgetID.l, addBanner.l = #False)
  ClearGadgetItemList(gadgetID)
  If addBanner
    AddGadgetItem(gadgetID, -1, "-- Tous --")
    SetGadgetState(gadgetID, 0)
  EndIf
EndProcedure


;{ Fill ComboGadget With something

  Procedure FillComboWithGenre(gadgetID.l, resize.l = 0, addBanner.l = #False)
    IniCombo(gadgetID, addBanner)
    DatabaseQuery(#Database, "SELECT * FROM genre ORDER BY nomGenre")
    While NextDatabaseRow(#Database)
      AddGadgetItem(gadgetID, -1, GetStrField("nomGenre"))
    Wend
    If resize
      ResizeComboBox(gadgetID, resize)
    EndIf
  EndProcedure
  
  
  Procedure FillComboWithActeur(gadgetID.l, resize.l, addBanner.l = #False)
    IniCombo(gadgetID, addBanner)
    DatabaseQuery(#Database, "SELECT * FROM acteur ORDER BY nomActeur")
    While NextDatabaseRow(#Database)
      AddGadgetItem(gadgetID, -1, GetStrField("nomActeur"))
    Wend
    ResizeComboBox(gadgetID, resize)
  EndProcedure

  Procedure FillComboWithSupport(gadgetID.l, resize.l = 0, addBanner.l = #False)
    IniCombo(gadgetID, addBanner)
    DatabaseQuery(#Database, "SELECT * FROM format ORDER BY nomFormat")
    While NextDatabaseRow(#Database)
      AddGadgetItem(gadgetID, -1, GetStrField("nomFormat"))
    Wend
    If resize
      ResizeComboBox(gadgetID, resize)
    EndIf
  EndProcedure
  
;}

Procedure FillMainWindowWithBD()
  IniCombo(#Combo_Date1, #True)
  IniCombo(#Combo_Date2, #True)
  
  ;{ Genres, Acteurs, Support
    FillComboWithGenre(#Combo_Genre,    #Size_Combo_Genre,  #True)
    FillComboWithActeur(#Combo_Acteur,  #Size_Combo_Acteur, #True)
    FillComboWithSupport(#Combo_Format, #Size_Combo_Format, #True)
  ;}
  
  ;{ Dates
    anneeCourante =  Val(FormatDate("%yyyy", Date()))
    annee = anneeCourante+1
    DatabaseQuery(#Database, "SELECT MIN(anneeFilm) as min FROM film WHERE anneeFilm <> 0")
    If NextDatabaseRow(#Database)
      annee = GetNumField("min")
      If annee = 0
        annee = anneeCourante+1
      EndIf
      ;Debug annee
    EndIf
    For i = annee To anneeCourante
      AddGadgetItem(#Combo_Date1, -1, Str(i))
      AddGadgetItem(#Combo_Date2, -1, Str(i))
    Next i
    ResizeComboBox(#Combo_Date1, 6)
    ResizeComboBox(#Combo_Date2, 6)
  ;}
  
EndProcedure



Procedure FillActorWindowWithBD()
  FillComboWithActeur(#Listview_Acteur, #Size_Combo_Acteur)
EndProcedure




Procedure.s AddNewFormat()
  format$ = InputRequester2(#Project_Name, "Nouveau format à ajouter :", "")
  If format$
    If DatabaseQuery(#Database, "INSERT INTO format (nomFormat) VALUES ("+ForUpdate(format$)+")")
      ProcedureReturn format$
    Else
      Warning("Le format existe déjà !")
    EndIf
  EndIf
  ProcedureReturn #NULL$
EndProcedure


Procedure.s AddNewGenre()
  genre$ = InputRequester2(#Project_Name, "Nouveau genre à ajouter :", "")
  If genre$
    If DatabaseQuery(#Database, "INSERT INTO genre (nomGenre) VALUES ("+ForUpdate(genre$)+")")
      ProcedureReturn genre$
    Else
      Warning("Le genre existe déjà !")
    EndIf
  EndIf
  ProcedureReturn #NULL$
EndProcedure


Procedure.s AddNewActeur()
  acteur$ = InputRequester2(#Project_Name, "Nouvel acteur à ajouter :", "")
  If acteur$
    ReplaceString(acteur$, ";", ",", 2)
    For i = 1 To CountString(acteur$, ",")+1
      If DatabaseQuery(#Database, "INSERT INTO acteur (nomActeur) VALUES ("+ForUpdate(StringField(acteur$, i, ","))+")")
        ; rien
      Else
        Warning("'" + Trim(StringField(acteur$, i, ",")) + "' existe déjà !")
      EndIf
    Next i
    ProcedureReturn acteur$
  EndIf
  ProcedureReturn #NULL$
EndProcedure



Procedure DeleteImageFilm(where$)
  If DatabaseQuery(#DataBase, "SELECT imageFilm FROM film WHERE "+where$)
    While NextDatabaseRow(#DataBase)
      image$ = GetStrField("imageFilm")
      If image$
        If Not(DeleteFile(#Folder_Affiche+image$))
          Debug "Can't delete '"+#Folder_Affiche+image$+"'"
        EndIf
      EndIf
    Wend
  Else
    Debug "Err{DeleteImageFilm} : "+where$
  EndIf

EndProcedure
; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 133
; FirstLine = 97
; Folding = ---
; EnableAsm
; EnableThread
