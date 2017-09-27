; PureBasic Visual Designer v3.95 build 1485 (PB4Code)


;- Window Constants
;
Enumeration
  #Window_Main
  #Window_AddMovie
  #Window_Actor
  #Window_Configuration
  #Window_SeeFilm
EndEnumeration

;- MenuBar Constants
;
Enumeration
  #MenuBar
  #StatusBar
EndEnumeration

Enumeration
  #MENU_Informations
  #MENU_GenFile
    #MENU_SaveCSV
    #MENU_SaveHTML
    #MENU_SaveFullHTML
  #MENU_Quitter
  #MENU_SeeFilm
  #MENU_AddFilm
  #MENU_EditFilm
  #MENU_DropFilm
  #MENU_Acteurs
  #MENU_Genres
  #MENU_Formats
  
  #KEY_Escape
EndEnumeration

;- Gadget Constants
;
Enumeration
  ; Fenetre principale
  #Frame3D_0
  #String_Search
  #Listview_Search
  #Text_1
  #Text_2
  #Text_3
  #Text_4
  #Text_5
  #Text_6
  #Combo_Genre
  #Combo_Acteur
  #Combo_Date1
  #Combo_Date2
  #Combo_Format
  #Button_AddMovie
  #Button_DropMovie
  #Button_EditMovie
  #Button_SeeMovie
  #Button_Format
  #Button_Acteur
  #Button_Genre
  #Button_Quitter

  ; Fentre d'ajout de films
  #Text_7
  #Text_8
  #Text_9
  #Text_10
  #Text_11
  #Text_12
  #Text_13
  #Text_14
  #Text_15
  #StringAdd_NomFilm
  #StringAdd_SousTitre
  #ComboAdd_Genre
  #ComboAdd_Format
  #StringAdd_Duree
  #Label_Duree
  #StringAdd_Annee
  #StringAdd_Image
  #EditorAdd_Synopsis
  #ButtonAdd_Genre
  #ButtonAdd_Format
  #ButtonAdd_Image
  #Frame3D_Acteurs
  #ListviewAdd_Acteur
  #ButtonAdd_AddAct
  #ButtonAdd_DropAct
  #ImageAdd_Acteur
  #ButtonAdd_Add
  #ButtonAdd_Cancel

  ; Fenêtre de choix d'acteur
  #Frame3D_SearchActor
  #Listview_Acteur
  #Text_16
  #String_Acteur
  #Button_ActorOk
  #Button_ActorCancel

  ; Fenêtre de configuration Genre / Format
  #Frame3D_Config
  #Button_RetourConfig
  #List_Config
  #Bt_Config_Add
  #Bt_Config_Edit
  #Bt_Config_Drop

  ; Fenêtre pour afficher les infos sur un film
  #ImageSee_NomFilm
  #TextSee_NomFilm
  #TextSee_SousNomFilm
  #TextSee_Acteurs
  #TextSee_Genre
  #TextSee_Format
  #TextSee_Annee
  #TextSee_Duree
  #EditorSee_Synopsis
  #BtImageSee_Prev
  #BtImageSee_Close
  #BtImageSee_Next
EndEnumeration



;- Image Plugins
UsePNGImageDecoder()
UseJPEGImageDecoder()



;- Image Globals
Global Image0, Image1, Image2, Image3, Image4, Image5, Image6, Image7
Global ImageAdd, ImageEdit, ImageDrop, ImagePrev, ImageNext, ImageClose
Global ImageAffiche, ImageRecord, ImageEditF, ImageCancel


;- Fonts
Global FontNomFilm, FontSousTitre
FontNomFilm = LoadFont(1, "Comic Sans MS", 16, #PB_Font_Bold | #PB_Font_HighQuality)
FontSousTitre = LoadFont(2, "Comic Sans MS", 11, #PB_Font_Bold | #PB_Font_HighQuality | #PB_Font_Italic)


;- Catch Images
Image0 = CatchImage(0, ?Image0)
Image1 = CatchImage(1, ?Image1)
Image2 = CatchImage(2, ?Image2)
Image3 = CatchImage(3, ?Image3)
Image4 = CatchImage(4, ?Image4)
Image5 = CatchImage(5, ?Image5)
Image6 = CatchImage(6, ?Image6)
Image7 = CatchImage(7, ?Image7)
ImageAdd  = CatchImage(8, ?ImageAdd)
ImageEdit = CatchImage(9, ?ImageEdit)
ImageDrop = CatchImage(10, ?ImageDrop)
ImagePrev  = CatchImage(11, ?ImagePrev)
ImageNext = CatchImage(12, ?ImageNext)
ImageClose = CatchImage(13, ?ImageClose)
ImageRecord = CatchImage(14, ?ImageRecord)
ImageEditF = CatchImage(15, ?ImageEditF)
ImageCancel = CatchImage(16, ?ImageCancel)


;- Images
DataSection
Image0:
  IncludeBinary "IMAGES\add_movie.ico"
Image1:
  IncludeBinary "IMAGES\formats.ico"
Image2:
  IncludeBinary "IMAGES\acteurs.ico"
Image3:
  IncludeBinary "IMAGES\genre.ico"
Image4:
  IncludeBinary "IMAGES\quitter.png"
Image5:
  IncludeBinary "IMAGES\edit_movie.ico"
Image6:
  IncludeBinary "IMAGES\drop_movie.ico"
Image7:
  IncludeBinary "IMAGES\see_movie.ico"
ImageAdd:
  IncludeBinary "IMAGES\add.ico"
ImageEdit:
  IncludeBinary "IMAGES\edit.ico"
ImageDrop:
  IncludeBinary "IMAGES\drop.ico"
ImagePrev:
  IncludeBinary "IMAGES\previous.ico"
ImageNext:
  IncludeBinary "IMAGES\next.ico"  
ImageClose:
  IncludeBinary "IMAGES\annuler.ico"
ImageRecord:
  IncludeBinary "IMAGES\record.ico"
ImageEditF:
  IncludeBinary "IMAGES\editF.ico"
ImageCancel:
  IncludeBinary "IMAGES\annuler.ico"
EndDataSection




Procedure Open_Main_Window()
  If OpenWindow(#Window_Main, 465, 590, 506, 290, "Div-X-Tech", #PB_Window_Invisible | #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_TitleBar )
    If CreateMenu(#MenuBar, WindowID(#Window_Main))
      MenuTitle("Fichier")
      MenuItem(#MENU_Informations, "Informations"+Chr(9)+"F1")
      OpenSubMenu("Enregistrer la liste")
        MenuItem(#MENU_SaveCSV,       "Fichier CSV")
        MenuItem(#MENU_SaveHTML,      "Fichier HTML")
        MenuItem(#MENU_SaveFullHTML,  "Fichier HTML avec les images")
      CloseSubMenu()
      MenuBar()
      MenuItem(#MENU_Quitter, "Quitter"+Chr(9)+"Alt+F4")
      
      MenuTitle("Films")
      MenuItem(#MENU_SeeFilm, "Voir l'affiche du film"+Chr(9)+"Ctrl+P")
      MenuItem(#MENU_AddFilm, "Ajouter un film"+Chr(9)+"Ctrl+A")
      MenuItem(#MENU_EditFilm, "Modifier le film"+Chr(9)+"Ctrl+M")
      MenuItem(#MENU_DropFilm, "Supprimer le film"+Chr(9)+"Suppr")
      MenuTitle("Configuration")
      MenuItem(#MENU_Acteurs, "Acteurs"+Chr(9)+"Ctrl+Alt+A")
      MenuItem(#MENU_Genres, "Genres"+Chr(9)+"Ctrl+Alt+G")
      MenuItem(#MENU_Formats, "Formats"+Chr(9)+"Ctrl+Alt+F")
      
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Alt | #PB_Shortcut_F4, #MENU_Informations)
      ;AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Control | #PB_Shortcut_S, #MENU_GenFile)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_F1, #MENU_Quitter)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Control | #PB_Shortcut_P, #MENU_SeeFilm)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Control | #PB_Shortcut_A, #MENU_AddFilm)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Control | #PB_Shortcut_M, #MENU_EditFilm)
      ;AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Delete, #MENU_DropFilm)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Alt | #PB_Shortcut_Control | #PB_Shortcut_A, #MENU_Acteurs)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Alt | #PB_Shortcut_Control | #PB_Shortcut_G, #MENU_Genres)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Alt | #PB_Shortcut_Control | #PB_Shortcut_F, #MENU_Formats)
    EndIf
    
    If CreateStatusBar(#StatusBar, WindowID(#Window_Main))
      AddStatusBarField(100)
    EndIf

    If CreateGadgetList(WindowID(#Window_Main))
      Frame3DGadget(#Frame3D_0, 10, 0, 490, 250, "Recherche d'un film")
      StringGadget(#String_Search, 20, 20, 235, 20, "")
      ListViewGadget(#Listview_Search, 20, 40, 235, 160)
      
      TextGadget(#Text_1, 270, 40, 50, 20, "Genre :")
      TextGadget(#Text_2, 270, 70, 50, 20, "Acteur :")
      TextGadget(#Text_3, 270, 100, 50, 20, "Date :")
      TextGadget(#Text_4, 340, 100, 50, 20, "Entre :")
      TextGadget(#Text_5, 340, 130, 50, 20, "Et :")
      TextGadget(#Text_6, 270, 160, 50, 20, "Format :")
      
      ComboBoxGadget(#Combo_Genre, 330, 35, 160, 20)
      ComboBoxGadget(#Combo_Acteur, 330, 65, 160, 20)
      ComboBoxGadget(#Combo_date1, 400, 95, 90, 20)
      ComboBoxGadget(#Combo_Date2, 400, 125, 90, 20)
      ComboBoxGadget(#Combo_Format, 330, 155, 160, 20)
      
      ButtonImageGadget(#Button_SeeMovie,   60, 205, 34, 34, Image7)
      ButtonImageGadget(#Button_AddMovie,  100, 205, 34, 34, Image0)
      ButtonImageGadget(#Button_EditMovie, 140, 205, 34, 34, Image5)
      ButtonImageGadget(#Button_DropMovie, 180, 205, 34, 34, Image6)
      
      ButtonImageGadget(#Button_Acteur,   310, 205, 34, 34, Image2)
      ButtonImageGadget(#Button_Genre,    350, 205, 34, 34, Image3)
      ButtonImageGadget(#Button_Format,   390, 205, 34, 34, Image1)
      ButtonImageGadget(#Button_Quitter,  450, 205, 34, 34, Image4)
      
      GadgetToolTip(#Button_AddMovie,   "Ajouter un film")
      GadgetToolTip(#Button_SeeMovie,   "Afficher un film")
      GadgetToolTip(#Button_EditMovie,  "Editer un film")
      GadgetToolTip(#Button_DropMovie,  "Supprimer un film")
      GadgetToolTip(#Button_Format,   "Gestion des formats")
      GadgetToolTip(#Button_Acteur,   "Gestion des acteurs")
      GadgetToolTip(#Button_Genre,    "Gestion des genres de film")
      GadgetToolTip(#Button_Quitter,  "Quitter "+#Project_Name)
    EndIf
  EndIf
EndProcedure




Procedure Open_Window_AddMovie()
  If OpenWindow(#Window_AddMovie, 516, 284, 380, 517, "",  #PB_Window_Invisible | #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window_AddMovie))
      TextGadget(#Text_7, 10, 10, 80, 20, "Nom du film :")
      TextGadget(#Text_8, 10, 40, 80, 20, "Sous titre :")
      TextGadget(#Text_9, 10, 70, 80, 20, "Genre :")
      TextGadget(#Text_10, 10, 100, 80, 20, "Durée :")
      TextGadget(#Text_11, 10, 130, 80, 20, "Année :")
      TextGadget(#Text_12, 10, 160, 80, 20, "Format :")
      TextGadget(#Text_13, 10, 190, 80, 20, "Image :")
      TextGadget(#Text_14, 10, 220, 80, 20, "Synopsis :")
      TextGadget(#Text_15, 230, 100, 80, 20, "minutes")
      
      StringGadget(#StringAdd_NomFilm, 90, 10, 280, 20, "")
      StringGadget(#StringAdd_SousTitre, 90, 40, 280, 20, "")
      ComboBoxGadget(#ComboAdd_Genre, 90, 70, 190, 20)
      StringGadget(#StringAdd_Duree, 90, 100, 130, 20, "")
      TextGadget(#Label_Duree, 230, 100, 80, 20, "")
      StringGadget(#StringAdd_Annee, 90, 130, 130, 20, "")
      ComboBoxGadget(#ComboAdd_Format, 90, 160, 190, 20)
      StringGadget(#StringAdd_Image, 90, 190, 240, 20, "")
      EditorGadget(#EditorAdd_Synopsis, 90, 220, 280, 110)
      ButtonGadget(#ButtonAdd_Genre, 290, 70, 80, 20, "Nouveau")
      ButtonGadget(#ButtonAdd_Format, 290, 160, 80, 20, "Nouveau")
      ButtonGadget(#ButtonAdd_Image, 340, 190, 30, 20, "...")
      SendMessage_(GadgetID(#EditorAdd_Synopsis),#EM_SETTARGETDEVICE,0,0)
      
      Frame3DGadget(#Frame3D_Acteurs, 10, 340, 360, 130, "Gestion des acteurs")
      ListViewGadget(#ListviewAdd_Acteur, 20, 360, 240, 100)
      ButtonGadget(#ButtonAdd_AddAct, 270, 410, 90, 20, "Ajouter")
      ButtonGadget(#ButtonAdd_DropAct, 270, 440, 90, 20, "Enlever")
      ButtonImageGadget(#ImageAdd_Acteur, 300, 360, 34, 34, Image2)

      ButtonImageGadget(#ButtonAdd_Add, 150, 480, 32, 32, ImageRecord)
      ButtonImageGadget(#ButtonAdd_Cancel, 195, 480, 32, 32, ImageCancel)
      
      AddKeyboardShortcut(#Window_AddMovie, #PB_Shortcut_Escape, #KEY_Escape)
    EndIf
  EndIf
EndProcedure



Procedure Open_Window_Actor()
  If OpenWindow(#Window_Actor, 465, 318, 271, 235, "Recherche d'un acteur", #PB_Window_Invisible | #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window_Actor))
      Frame3DGadget(#Frame3D_SearchActor, 0, 10, 270, 190, "Recherche d'un acteur")
      ListViewGadget(#Listview_Acteur, 10, 60, 250, 130)
      TextGadget(#Text_16, 10, 30, 100, 20, "Contenant les mots :")
      StringGadget(#String_Acteur, 120, 30, 140, 20, "")
      ButtonGadget(#Button_ActorOk, 40, 210, 90, 20, "Ok")
      ButtonGadget(#Button_ActorCancel, 140, 210, 90, 20, "Retour")
      
      AddKeyboardShortcut(#Window_Actor, #PB_Shortcut_Escape, #KEY_Escape)
    EndIf
  EndIf
EndProcedure



Procedure Open_Window_Configuration()
  If OpenWindow(#Window_Configuration, 574, 420, 267, 202, "Gestion des genres", #PB_Window_Invisible | #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window_Configuration))
      Frame3DGadget(#Frame3D_Config, 10, 10, 250, 160, "Gestion des genres")
      ButtonGadget(#Button_RetourConfig, 70, 175, 110, 20, "Retour")
      ListViewGadget(#List_Config, 20, 30, 190, 130)
      ButtonImageGadget(#Bt_Config_Add, 220, 40, 32, 32, ImageAdd)
      ButtonImageGadget(#Bt_Config_Edit, 220, 80, 32, 32, ImageEdit)
      ButtonImageGadget(#Bt_Config_Drop, 220, 120, 32, 32, ImageDrop)
      
      AddKeyboardShortcut(#Window_Configuration, #PB_Shortcut_Escape, #KEY_Escape)
    EndIf
  EndIf
EndProcedure



Procedure Open_Window_SeeFilmsInformations()
  If OpenWindow(#Window_SeeFilm, 481, 159, 529, 277, "",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_Invisible | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
    If CreateGadgetList(WindowID(#Window_SeeFilm))
      ImageGadget(#ImageSee_NomFilm, 400, 50, 120, 175, -1)
      TextGadget(#TextSee_NomFilm, 10, 10, 510, 30, "Nom du film", #PB_Text_Center)
      SetGadgetFont(#TextSee_NomFilm, FontNomFilm)
      SetGadgetColor(#TextSee_NomFilm, #PB_Gadget_FrontColor, $FF0000)
      TextGadget(#TextSee_SousNomFilm, 10, 40, 370, 20, "Sous Titre")
      SetGadgetFont(#TextSee_SousNomFilm, FontSousTitre)
      SetGadgetColor(#TextSee_SousNomFilm, #PB_Gadget_FrontColor, $FF0080)
      TextGadget(#TextSee_Acteurs, 10, 70, 370, 20, "Liste des acteurs : Brat Piit, Jim Carrey, etc...")
      TextGadget(#TextSee_Genre, 10, 90, 190, 20, "Genre : Comédie")
      TextGadget(#TextSee_Format, 200, 90, 180, 20, "Format : DVD")
      TextGadget(#TextSee_Annee, 10, 110, 190, 20, "Année : 2000")
      TextGadget(#TextSee_Duree, 200, 110, 180, 20, "Durée : 1h30")
      EditorGadget(#EditorSee_Synopsis, 10, 140, 370, 130, #PB_Editor_ReadOnly)
      ButtonImageGadget(#BtImageSee_Prev, 405, 230, 32, 32, ImagePrev)
      ButtonImageGadget(#BtImageSee_Close, 442, 230, 32, 32, ImageClose)
      ButtonImageGadget(#BtImageSee_Next, 478, 230, 32, 32, ImageNext)
      
      GadgetToolTip(#BtImageSee_Prev,   "Film précédant")
      GadgetToolTip(#BtImageSee_Close,  "Fermer cette fenêtre")
      GadgetToolTip(#BtImageSee_Next,   "Film suivant")
      SendMessage_(GadgetID(#EditorSee_Synopsis),#EM_SETTARGETDEVICE,0,0)
      
      AddKeyboardShortcut(#Window_SeeFilm, #PB_Shortcut_Escape, #KEY_Escape)
    EndIf
  EndIf
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 215
; FirstLine = 204
; Folding = -
; EnableAsm
; EnableThread
