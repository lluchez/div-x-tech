

;{ Les includes
  IncludeFile "ini.pb"
  IncludeFile "basic_fcts.pb"
  IncludeFile "fct_bd.pb"
  IncludeFile "intGraph.pb"
  IncludeFile "fct_bd_2.pb"
  IncludeFile "fct_show_hide.pb"
  IncludeFile "fct_event.pb"
;}



;{ Initialisation de la BD
  If BD_Connect("", "")=#Null
    End
  EndIf
;}



;{ Création des fenêtres
  Open_Main_Window()
  Open_Window_AddMovie()
  Open_Window_Actor()
  Open_Window_Configuration()
  Open_Window_SeeFilmsInformations()
;}


SetWindowCallback(@ProgramCallback())

ShowMainWindow()
UpdateSearchFilm()



;{ Boucle Principale
  Repeat
  
  ;{ ------------ WaitWindowEvent ------------------
    Select WaitWindowEvent()
      
      
      Case #PB_Event_Menu
      
      ;{ Choix d'un item dans la barre de Menu
        Select EventMenu()
          
          Case #MENU_Informations
		  
		      Case #MENU_GenFile
		      Case #MENU_SaveCSV
          Case #MENU_SaveHTML
          Case #MENU_SaveFullHTML
		    
          
          Case #MENU_Quitter
            QuitProgram()
          
          
          Case #MENU_SeeFilm
            OpenSeeMovieWindow()
            
          Case #MENU_AddFilm
            OpenAddMovieWindow()
          
          Case #MENU_EditFilm
            If GetGadgetState(#Listview_Search) <> -1
              OpenEditMovieWindow()
            EndIf
          
          Case #MENU_DropFilm
            If GetGadgetState(#Listview_Search) <> -1
              DropMovie()
            EndIf
          
          
          Case #MENU_Acteurs
            ShowConfigActeurWindow()
          
          Case #MENU_Genres
            ShowConfigGenreWindow()
          
          Case #MENU_Formats
            ShowConfigFormatWindow()
        
        EndSelect
      ;}
      
      
      
      Case #PB_Event_Gadget
      
      ;{ Boutons qui a intéragit
        Select EventGadget()
        
          Case #Button_Quitter
            QuitProgram()
          
          Case #Button_AddMovie
            OpenAddMovieWindow()
          
          Case #Button_SeeMovie
            OpenSeeMovieWindow()
          
          Case #Button_EditMovie
            OpenEditMovieWindow()
          
          Case #Button_DropMovie
            DropMovie()
          
          Case #Listview_Search
            UpdateSeeEditDropFilmButton()
        
        
        ;{ Event dans SeeFilmWindow
          Case #BtImageSee_Prev
            SetGadgetState(#Listview_Search, GetGadgetState(#Listview_Search)-1)
            UpdateSeeFilmWindowInformations(GetGadgetState(#Listview_Search))
          
          Case #BtImageSee_Next
            SetGadgetState(#Listview_Search, GetGadgetState(#Listview_Search)+1)
            UpdateSeeFilmWindowInformations(GetGadgetState(#Listview_Search))
          
          Case #BtImageSee_Close
            CloseSeeMovieWindow()
        ;}
        
          
        ;{ Gestion d'ajout d'un film
          Case #ButtonAdd_Image
            image$ = OpenFileRequester("Sélection d'une affiche", "", "Fichiers images|*.bmp;*.jpeg;*.jpg;*.png", 0)
            If image$
              SetGadgetText(#StringAdd_Image, image$)
            EndIf
          
          Case #ButtonAdd_Add
            ;If GetGadgetText(#ButtonAdd_Add) = #Text_Add_Film
            If GetWindowTitle(#Window_AddMovie) = #Title_Add_Film
              Debug "ok !!"
              ValidateAddMovie()
            Else
              ValidateEditMovie()
            EndIf
          
          Case #ButtonAdd_Cancel
            CancelAddMovie()
          
          Case #ButtonAdd_AddAct
            OpenActorWindow()
          
          Case #ButtonAdd_DropAct
            index = GetGadgetState(#ListviewAdd_Acteur)
            If index > -1
              RemoveGadgetItem(#ListviewAdd_Acteur, index)
              SelectElement(ListIndexActorOfFilm(), index)
              DeleteElement(ListIndexActorOfFilm())
            EndIf
          
          Case #StringAdd_Duree
            If EventType() = #PB_EventType_Change
              SetGadgetText(#Label_Duree, "Soit : " + MinutesToString(Val(GetGadgetText(#StringAdd_Duree))))
            EndIf
        ;}
        

          Case #Button_ActorCancel
            CancelSearchForActor()
          
          Case #Listview_Acteur
            Select EventType()
              Case #PB_EventType_LeftClick
                If GetGadgetState(#Listview_Acteur) = -1
                  DisableGadget(#Button_ActorOk, #True)
                Else
                  DisableGadget(#Button_ActorOk, #False)
                EndIf
              Case #PB_EventType_LeftDoubleClick
                AddActorOfFilmToList()
            EndSelect
          
          Case #ListviewAdd_Acteur
            If EventType() = #PB_EventType_LeftClick
              If GetGadgetState(#ListviewAdd_Acteur) = -1
                DisableGadget(#ButtonAdd_DropAct, #True)
              Else
                DisableGadget(#ButtonAdd_DropAct, #False)
              EndIf
            EndIf
          
          Case #Button_ActorOk
            AddActorOfFilmToList()

          Case #Button_RetourConfig
            CancelConfigurate()
          
          
        ;{ Gestion des Acteurs, Genres et Formats
          Case #ImageAdd_Acteur, #Button_Acteur
            ShowConfigActeurWindow()
          
          Case #Button_Genre
            ShowConfigGenreWindow()
          
          Case #ButtonAdd_Genre
            AddGenre()
          
          Case #Button_Format
            ShowConfigFormatWindow()
          
          Case #ButtonAdd_Format
            AddFormat()
        ;}
          
        
        ;{ Mise à jour de la liste des acteurs (recherche)
          Case #String_Acteur
            If EventType() = #PB_EventType_Change
              UpdateSearchActor()
            EndIf
        ;}
          
        ;{ Mise à jour de la liste de film (recherche)
           Case #String_Search
            If EventType() = #PB_EventType_Change
              UpdateSearchFilm()
            EndIf
          
          Case #Combo_Genre, #Combo_Acteur, #Combo_Date1, #Combo_Date2, #Combo_Format
            If EventType() = #PB_EventType_ComboChanged
              UpdateSearchFilm()
            EndIf
        ;}
        
        
        ;{ Gestion des Genres / Formats [Configuration]
          Case #List_Config
            If GetGadgetState(#List_Config) = -1
              etat = #True
            Else
              etat = #False
            EndIf
            DisableGadget(#Bt_Config_Edit, etat)
            DisableGadget(#Bt_Config_Drop, etat)
          
          Case #Bt_Config_Add
            Select Config\nomTable
              Case "acteur"
                If AddActeur()
                  ActualiseListViewWithConfig()
                EndIf
              Case "genre"
                If AddGenre()
                  ActualiseListViewWithConfig()
                EndIf
              Case "format"
                If AddFormat()
                  ActualiseListViewWithConfig()
                EndIf
            EndSelect
            
          Case #Bt_Config_Edit
            If GetGadgetState(#List_Config) > 0
              retour$ = EditConfiguration(GetGadgetText(#List_Config))
              If retour$
                ActualiseMainWindowAfterConfiguration()
              EndIf
            EndIf
            
          Case #Bt_Config_Drop
            If GetGadgetState(#List_Config) > 0
              retour = DropConfiguration(GetGadgetText(#List_Config))
              If retour
                ActualiseMainWindowAfterConfiguration()
              EndIf
            EndIf
        ;}
          
          
        EndSelect
      ;}
      
    EndSelect
  ;}
  
  
  If GetAsyncKeyState_(#PB_Shortcut_Delete)
    If GetActiveGadget() = #Listview_Search
      If GetGadgetState(#Listview_Search) <> -1
        DropMovie()
      EndIf
    EndIf
  EndIf
  
  
  ForEver
;}


; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 53
; FirstLine = 36
; Folding = ---
; EnableAsm
; EnableThread
; UseIcon = divx.ico
; Executable = Div-X-Tech.exe 
; jaPBe Version=3.7.11.672
; Build=0
; FirstLine=0
; CursorPosition=17
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF