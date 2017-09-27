

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
; IsNumeric : returns True if value is numerical


Procedure IsNumeric(t$)
  For i = 1 To Len(t$)
    If Asc(Mid(t$, i, 1)) < '0' Or Asc(Mid(t$, i, 1)) > '9'
      ProcedureReturn #False
    EndIf
  Next i
  ProcedureReturn #True
EndProcedure



; -----------------------------------------------------------------
; SetComboText

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

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 55
; FirstLine = 54
; Folding = ---
; EnableAsm
; EnableThread
