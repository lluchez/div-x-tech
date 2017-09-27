

#Project_Name = "Div-X-Tech"
#PB_EventType_ComboChanged = #PB_EventType_RightClick


#Folder_Affiche = "Affiche/"

#ImageIndex_Affiche = 1000


; -----------------------------------------------------------------
;- Normalize : IO/DataBase


Procedure.s Normalize(s$)
  ReplaceString(s$, "'", Chr(34), 2)
  ProcedureReturn Trim(s$)
EndProcedure


Procedure.s ForUpdate(s$)
  s$ = Normalize(s$)
  ProcedureReturn(" '" + s$ + "' ")
EndProcedure

Macro NormalizedGadgetText(gadgetID)
  ForUpdate(GetGadgetText(gadgetID))
EndMacro



; -----------------------------------------------------------------
;- MessageRequester


Procedure Alert(message.s, title.s = #Project_Name + " - Erreur")
  MessageRequester(title, message, #MB_ICONERROR)
EndProcedure


Procedure Warning(message.s, title.s = #Project_Name + " - Attention")
  MessageRequester(title, message, #MB_ICONWARNING)
EndProcedure



; -----------------------------------------------------------------
;- IsNumeric : returns True if value is numerical


Procedure IsNumeric(t$)
  For i = 1 To Len(t$)
    If Asc(Mid(t$, i, 1)) < '0' Or Asc(Mid(t$, i, 1)) > '9'
      ProcedureReturn #False
    EndIf
  Next i
  ProcedureReturn #True
EndProcedure



; -----------------------------------------------------------------
;- SetComboText

Procedure SetComboText(gadgetID, value.s, column = -1)
  For i = 0 To CountGadgetItems(gadgetID)-1
    If GetGadgetItemText(gadgetID, i, column) = value
      SetGadgetState(gadgetID, i)
      ProcedureReturn #True
    EndIf
  Next
  ProcedureReturn #False
EndProcedure



Procedure DataBase_GetOneRow(DataBase.l, query.s)
  If DatabaseQuery(Database, query)
    If NextDatabaseRow(Database)
      ProcedureReturn #True
    EndIf
  EndIf
  ProcedureReturn #False
EndProcedure



Macro AddElementAtEnd(liste, chaine)
  LastElement(liste)
  AddElement(liste)
  liste = chaine
EndMacro



Macro InputRequester2(title, message, Def)
  Trim(InputRequester(title, message, Def))
EndMacro




Procedure.s MinutesToString(minutes)
  h = minutes/60
  m = minutes%60
  ProcedureReturn Str(h)+"h"+RSet(Str(m),2,"0")
EndProcedure



Procedure.s Implode(list.s(), separator.s = ",") ; List to String
  Protected result.s, size.l = CountList(list()) - 1
 
  ForEach list()
    result + list()
    If (ListIndex(list()) < size)
      result + separator
    EndIf
  Next
  ProcedureReturn result
EndProcedure 




Procedure Egal(n1, n2)
  If n1 = n2
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure Different(n1, n2)
  If n1 <> n2
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure


Procedure Inferieur(n1, n2)
  If n1 < n2
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure Superieur(n1, n2)
  If n1 > n2
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure




;---------------------------------------------------------------


;- Types de donnees des rows

Enumeration 0
  #ODBC_UNKNOW
  #ODBC_NUMERIC
  #ODBC_STRING
  #ODBC_FLOAT
EndEnumeration


;- Types de donnees de la BD

Dim DatabaseType.s(4) 
  DatabaseType(#ODBC_UNKNOW)  = "Unknown" 
  DatabaseType(#ODBC_NUMERIC) = "Numeric" 
  DatabaseType(#ODBC_STRING)  = "String" 
  DatabaseType(#ODBC_FLOAT)   = "Float" 




Global hasBD.b, DSN.s


#Database           = 1
#BD_NAME$           = "divx.mdb"
DSN = "pbtest"


Enumeration 1
  #ODBC_ADD_DSN            ; Add a new user Data source.
  #ODBC_CONFIG_DSN         ; Configure (modify) an existing user Data source.
  #ODBC_REMOVE_DSN         ; Remove an existing user Data source.
  #ODBC_ADD_SYS_DSN        ; Add a new system Data source.
  #ODBC_CONFIG_SYS_DSN     ; Modify an existing system Data source.
  #ODBC_REMOVE_SYS_DSN     ; Remove an existing system Data source.
  #ODBC_REMOVE_DEFAULT_DSN ; Remove the default data source specification section from the system information.
EndEnumeration

#ODBC_DRIVER_MSACCESS = "Microsoft Access Driver (*.mdb)"




Procedure.l MSAccess_AddConnection(name.s, database.s, hwnd.l = #Null)
  Protected attrs.s
 
  attrs + "UID="         + ";"
  attrs + "PWD="         + ";"
  attrs + "DSN="         + name + ";"
  attrs + "DBQ="         + database + ";"
  attrs + "FIL="         + "MS Access;"
  attrs + "Driver="      + "ODBCJT32.DLL;"
  attrs + "DefaultDir="  + GetPathPart(database) + ";"
  attrs + "Description=" + FormatDate("Créé le %dd-%mm-%yyyy, %hh:%ii:%ss;", Date())
 
  ReplaceString(attrs, ";", #NULL$, 2)
  ProcedureReturn SQLConfigDataSource_(hWnd, #ODBC_ADD_DSN, #ODBC_DRIVER_MSACCESS, attrs)
EndProcedure

Procedure.l MSAccess_RemoveConnection(name.s, hwnd.l = #Null)
  ProcedureReturn SQLConfigDataSource_(hWnd, #ODBC_REMOVE_DSN, #ODBC_DRIVER_MSACCESS, "DSN="+name)
EndProcedure


;- Connexion a la BD

Procedure BD_Connect(user$, pass$)
  If InitDatabase()=#Null
    MessageRequester("Error", "Impossible d'initialiser les drivers BD", #MB_ICONERROR)
    hasBD = #False
    ProcedureReturn #False
  EndIf
  If MSAccess_AddConnection(DSN, #BD_NAME$) = 0
    MessageRequester("Error", "Impossible de créer la connexion à la BD", #MB_ICONERROR)
    hasBD = #False
    ProcedureReturn #False
  EndIf
  ;If OpenDatabase(#Database, #ODBC_DNS$, user$, pass$)=0 ; DSN
  If OpenDatabase(#Database, DSN, user$, pass$)=0
    MessageRequester("Error", "Impossible d'ouvrir la BD", #MB_ICONERROR)
    hasBD = #False
    ProcedureReturn #False
  EndIf
  
  hasBD = #True
  ProcedureReturn #True
EndProcedure


Procedure BD_Close()
  CloseDatabase(#DataBase)
  ;UnIniConnection()
  MSAccess_RemoveConnection(DSN.s)
  hasBD = #False
EndProcedure









;- Recupere un champs apres requete

Procedure FindIndiceField(champ$)
  Protected k.b
  
  For k=0 To DatabaseColumns(#Database)-1 
    If DatabaseColumnName(#Database, k) = champ$
      ProcedureReturn k
    EndIf
  Next k
  
  For k=0 To DatabaseColumns(#Database)-1 
    If UCase(DatabaseColumnName(#Database, k)) = UCase(champ$)
      ProcedureReturn k
    EndIf
  Next k
  
  Debug ">> Erreur FindIndiceField <<"
  Debug champ$
EndProcedure


Procedure.s GetStrField(champ$)
  Protected ind.b, s$
    ind = FindIndiceField(champ$)
    s$ = GetDatabaseString(#Database, ind)
    ReplaceString(s$, Chr(34), "'", 2)
    ProcedureReturn s$
EndProcedure


Procedure.l GetNumField(champ$)
  Protected ind.b
    ind = FindIndiceField(champ$)
    ProcedureReturn GetDatabaseLong(#Database, ind)
EndProcedure


Procedure.f GetFloatField(champ$)
  Protected ind.b
    ind = FindIndiceField(champ$)
    ProcedureReturn GetDatabaseFloat(#Database, ind)
EndProcedure






;- Index nouvelle ligne (Auto-Increment)

Procedure.l GetNewLine(table$, champ$)
  If DatabaseQuery(#Database, "SELECT MAX("+champ$+") as max FROM " + table$)
    If NextDatabaseRow(#Database)
      ProcedureReturn(GetNumField("max")+1)
    Else
      ProcedureReturn(1)
    EndIf
  Else
    Debug " -> Erreur dans la recherche du MAX"
    ProcedureReturn(0)
  EndIf
EndProcedure



;- Max from table

Procedure.l GetMaxTable(table$, champ$)
  If DatabaseQuery(#Database, "SELECT MAX("+champ$+") as max FROM " + table$)
    If NextDatabaseRow(#Database)
      ProcedureReturn(GetNumField("max"))
    Else
      ProcedureReturn(0)
    EndIf
  Else
    Debug " -> Erreur dans la recherche du MAX"
    ProcedureReturn(0)
  EndIf
EndProcedure



;- Get Index of a Row

Procedure.l GetIndexRow(table$, value$, stringField$, numField$)
  query$ = "SELECT "+numField$+" FROM " + table$ + " WHERE "+stringField$+" = "+ForUpdate(value$)
  ;Debug query$
  If DatabaseQuery(#Database, query$)
    If NextDatabaseRow(#Database)
      ProcedureReturn(GetNumField(numField$))
    Else
      Debug "ERR: GetIndexRow -> Pas de ligne sélectionné"
      ProcedureReturn(0)
    EndIf
  Else
    Debug "ERR: GetIndexRow -> Erreur dans la requête"
    ProcedureReturn(0)
  EndIf

EndProcedure





;---------------------------------------------------------------



Macro QuitProgram()
  ;Debug "Close"
  BD_Close()
  End
EndMacro


Procedure.b isHex(text$, *val.Long)
  Protected i.l, car.b, power.l

  power = 1
  *val\l = 0
  text$ = UCase(text$)
  If Left(text$, 1) = "$"
    text$ = Right(text$, Len(text$)-1)
  EndIf
  
  For i = Len(text$)-1 To 0 Step -1
    car = PeekB(@text$ + i)
    If car < '0' Or (car > '9' And car <'A') Or car > 'F'
      *val\l = 0
      ProcedureReturn #False
    EndIf
    If car >= 'A'
      car = car + 10 - 'A'
    Else
      car - '0'
    EndIf
    *val\l = *val\l + (car * power)
    power << 4
  Next i
  ProcedureReturn #True
EndProcedure




Procedure.s FileToString__(path$, *size.Long)
  Protected string.s, hFile.l, car.c
  *size\l = FileSize(path$)
  If *size\l > 0
    hFile = OpenFile(#PB_Any, path$)
    If hFile
      cpt = 0
      ;*str = AllocateMemory(*size\l * 2)
      ;*ptr.Byte = *str
      While Not(Eof(hFile))
        car = ReadByte(hFile)
        string + Right(Hex(car & $FF), 2)
        ;string = Right(Hex(car & $FF), 2)
        ;Debug string
        ;*ptr\b = PeekB(@string)
        ;*ptr\b + 1
        ;*ptr\b = PeekB(@string + 1)
        ;*ptr\b + 1
        cpt + 1
      Wend
      Debug "cpt : " + Str(cpt)
      ;*ptr\b = 0
    EndIf
  EndIf
  ProcedureReturn string
  ;ProcedureReturn *str
EndProcedure


Procedure.s FileToString(FileName.s, *size.Long)
  Protected file.l, string.s
  file = ReadFile(#PB_Any, FileName)
  *size\l = Lof(file)
  If file
    string = Space(Lof(file))
    ReadData(file, @string, *size\l)
    CloseFile(file)
  EndIf
  ProcedureReturn string
EndProcedure




Procedure StringToFile(chaine$, dest$, taille.l = 0)
  If taille = #Null
    taille = Len(chaine$) / 2
  EndIf
  
  Debug taille
EndProcedure



s$ = FileToString("F:\Mes documents\## Pictures ##\FËTES\Copie de lio.JPG", @size.l)
;s$ = PeekS(mem)
Debug s$
Debug mem
Debug size
Debug Len(s$)
StringToFile(s$, "coucou.jpg")
;FreeMemory(mem)
End


;- --- Debut ------


;{ Initialisation de la BD
  If BD_Connect("", "")=#Null
    End
  EndIf
;}








Debug "ok"


;Debug DatabaseQuery(#Database, "INSERT INTO temp VALUES(3, 'F:\Mes documents\## Pictures ##\Arrières plan\Mes dessins\alpes.jpg')")
Debug DatabaseQuery(#Database, "SELECT image FROM temp WHERE num=1")
Debug NextDatabaseRow(#Database)
Debug DatabaseColumns(#Database)
Debug DatabaseColumnType(#Database, 0)
file$ = GetStrField("image")
target$ = ""
Debug file$
Debug Len(file$)
;OpenFile(0, "test.jpg")
*pointeur.Byte = @file$
While *pointeur\b <> 0
  text$ = Chr(*pointeur\b)
  *pointeur + 1
  text$ +Chr(*pointeur\b)
  ;Debug text$
  *pointeur + 1
  isHex(text$, @retour.l)
  target$ + Chr(retour)
  ;WriteByte(0, retour)
Wend
Debug target$
;CloseFile(0)


QuitProgram()
; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 471
; FirstLine = 435
; Folding = ------
; EnableAsm
; EnableThread
