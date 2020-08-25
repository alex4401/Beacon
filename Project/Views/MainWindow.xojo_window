#tag Window
Begin BeaconWindow MainWindow Implements AnimationKit.ValueAnimator,ObservationKit.Observer,NotificationKit.Receiver
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   True
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   True
   HasBackColor    =   False
   Height          =   680
   ImplicitInstance=   False
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   817604607
   MenuBarVisible  =   True
   MinHeight       =   680
   MinimizeButton  =   True
   MinWidth        =   1200
   Placement       =   2
   Resizable       =   "True"
   Resizeable      =   True
   SystemUIVisible =   "True"
   Title           =   "Beacon"
   Visible         =   True
   Width           =   1200
   Begin TabBar TabBar1
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      Count           =   0
      DoubleBuffer    =   False
      Enabled         =   True
      Height          =   25
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   21
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      ScrollSpeed     =   20
      SelectedIndex   =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   -115
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   1159
      WithTopBorder   =   False
   End
   Begin PagePanel Views
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   337
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   41
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      PanelCount      =   2
      Panels          =   ""
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      Top             =   -409
      Transparent     =   False
      Value           =   0
      Visible         =   True
      Width           =   759
   End
   Begin ControlCanvas OverlayCanvas
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      Height          =   380
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   -512
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      ScrollSpeed     =   20
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   584
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   False
      Width           =   500
   End
   Begin LibraryPane LibraryPane1
      AcceptFocus     =   False
      AcceptTabs      =   True
      AutoDeactivate  =   True
      BackColor       =   &cFFFFFF00
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      HasBackColor    =   False
      Height          =   680
      HelpTag         =   ""
      InitialParent   =   ""
      Left            =   -323
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   -420
      Transparent     =   True
      UseFocusRing    =   False
      Visible         =   True
      Width           =   300
   End
   Begin OmniBar NavBar
      Alignment       =   0
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      Height          =   38
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LeftPadding     =   -1
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RightPadding    =   -1
      Scope           =   2
      ScrollSpeed     =   20
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Visible         =   True
      Width           =   1200
   End
   Begin PagePanel Pages
      AllowAutoDeactivate=   True
      Enabled         =   True
      Height          =   642
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelCount      =   5
      Panels          =   ""
      Scope           =   2
      TabIndex        =   6
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   38
      Transparent     =   False
      Value           =   4
      Visible         =   True
      Width           =   1200
      Begin DocumentsComponent DocumentsComponent1
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         AllowFocusRing  =   False
         AllowTabs       =   True
         Backdrop        =   0
         BackgroundColor =   &cFFFFFF00
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         HasBackgroundColor=   False
         Height          =   642
         InitialParent   =   "Pages"
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         MinimumHeight   =   300
         MinimumWidth    =   400
         Scope           =   2
         TabIndex        =   0
         TabPanelIndex   =   2
         TabStop         =   True
         Tooltip         =   ""
         Top             =   38
         Transparent     =   True
         Visible         =   True
         Width           =   1200
      End
      Begin HTMLViewer HelpViewer
         AllowAutoDeactivate=   True
         Enabled         =   True
         Height          =   642
         Index           =   -2147483648
         InitialParent   =   "Pages"
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Renderer        =   0
         Scope           =   2
         TabIndex        =   0
         TabPanelIndex   =   5
         TabStop         =   True
         Tooltip         =   ""
         Top             =   38
         Visible         =   True
         Width           =   1200
      End
      Begin DashboardPane DashboardPane1
         AcceptFocus     =   False
         AcceptTabs      =   True
         AutoDeactivate  =   True
         BackColor       =   &cFFFFFF00
         Backdrop        =   0
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         HasBackColor    =   False
         Height          =   642
         HelpTag         =   ""
         InitialParent   =   "Pages"
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         MinimumHeight   =   300
         MinimumWidth    =   400
         Scope           =   2
         TabIndex        =   0
         TabPanelIndex   =   1
         TabStop         =   True
         Top             =   38
         Transparent     =   True
         UseFocusRing    =   False
         Visible         =   True
         Width           =   1200
      End
      Begin BlueprintsComponent BlueprintsComponent1
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         AllowFocusRing  =   False
         AllowTabs       =   True
         Backdrop        =   0
         BackgroundColor =   &cFFFFFF00
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         HasBackgroundColor=   False
         Height          =   642
         InitialParent   =   "Pages"
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         MinimumHeight   =   300
         MinimumWidth    =   400
         Scope           =   2
         TabIndex        =   0
         TabPanelIndex   =   3
         TabStop         =   True
         Tooltip         =   ""
         Top             =   38
         Transparent     =   True
         Visible         =   True
         Width           =   1200
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Function CancelClose(appQuitting as Boolean) As Boolean
		  #Pragma Unused AppQuitting
		  
		  Var ModifiedViews() As BeaconSubview
		  
		  For Each View As BeaconSubview In Self.mSubviews
		    If View.Changed Then
		      ModifiedViews.AddRow(View)
		    End If
		  Next
		  
		  Select Case ModifiedViews.LastRowIndex
		  Case -1
		    Return False
		  Case 0
		    Return Not Self.DiscardView(ModifiedViews(0))
		  Else
		    Var NumChanges As Integer = ModifiedViews.LastRowIndex + 1
		    
		    Var Dialog As New MessageDialog
		    Dialog.Title = ""
		    Dialog.Message = "You have " + NumChanges.ToString + " documents with unsaved changes. Do you want to review these changes before quitting?"
		    Dialog.Explanation = "If you don't review your documents, all your changes will be lost."
		    Dialog.ActionButton.Caption = "Review Changes…"
		    Dialog.CancelButton.Visible = True
		    Dialog.AlternateActionButton.Caption = "Discard Changes"
		    Dialog.AlternateActionButton.Visible = True
		    
		    Var Choice As MessageDialogButton = Dialog.ShowModalWithin(Self)
		    If Choice = Dialog.ActionButton Then
		      For Each View As BeaconSubview In ModifiedViews
		        If Not Self.DiscardView(View) Then
		          Return True
		        End If
		      Next
		      Return False
		    ElseIf Choice = Dialog.CancelButton Then
		      Return True
		    ElseIf Choice = Dialog.AlternateActionButton Then
		      For Each View As BeaconSubview In ModifiedViews
		        View.DiscardChanges()
		      Next
		      Return False
		    End If
		  End Select
		End Function
	#tag EndEvent

	#tag Event
		Sub Close()
		  NotificationKit.Ignore(Self, App.Notification_UpdateFound, BeaconSubview.Notification_ViewShown)
		  #if TargetMacOS
		    NSNotificationCenterMBS.DefaultCenter.RemoveObserver(Self.mObserver)
		  #endif
		End Sub
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  If Self.mCurrentView <> Nil Then
		    Self.mCurrentView.EnableMenuItems()
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Moved()
		  If Self.mOpened Then
		    Var Bounds As Xojo.Rect = Self.Bounds
		    Preferences.MainWindowPosition = New Rect(Bounds.Left, Bounds.Top, Bounds.Width, Bounds.Height)
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  Var Frame As Rect = Self.Bounds
		  Var XDelta As Integer = Frame.Width - Self.Width
		  Var YDelta As Integer = Frame.Height - Self.Height
		  Self.MinimumWidth = Self.MinimumWidth - XDelta
		  Self.MinimumHeight = Self.MinimumHeight - YDelta
		  Self.Width = Max(Self.Width, Self.MinimumWidth)
		  Self.Height = Max(Self.Height, Self.MinimumHeight)
		  
		  Var Bounds As Rect = Preferences.MainWindowPosition
		  If Bounds <> Nil Then
		    // Find the best screen
		    Var IdealScreen As Screen = Screen(0)
		    If ScreenCount > 1 Then
		      Var MaxArea As Integer
		      For I As Integer = 0 To ScreenCount - 1
		        Var ScreenBounds As New Rect(Screen(I).AvailableLeft, Screen(I).AvailableTop, Screen(I).AvailableWidth, Screen(I).AvailableHeight)
		        Var Intersection As Rect = ScreenBounds.Intersection(Bounds)
		        If Intersection = Nil Then
		          Continue
		        End If
		        Var Area As Integer = Intersection.Width * Intersection.Height
		        If Area <= 0 Then
		          Continue
		        End If
		        If Area > MaxArea Then
		          MaxArea = Area
		          IdealScreen = Screen(I)
		        End If
		      Next
		    End If
		    
		    Var AvailableBounds As New Rect(IdealScreen.AvailableLeft, IdealScreen.AvailableTop, IdealScreen.AvailableWidth, IdealScreen.AvailableHeight)
		    Var WidthRange As New Beacon.Range(Self.MinimumWidth + XDelta, Self.MaximumWidth + XDelta)
		    Var HeightRange As New Beacon.Range(Self.MinimumHeight + YDelta, Self.MaximumHeight + YDelta)
		    Var Width As Integer = WidthRange.Fit(Min(Bounds.Width, AvailableBounds.Width))
		    Var Height As Integer = HeightRange.Fit(Min(Bounds.Height, AvailableBounds.Height))
		    Var Left As Integer = Max(Min(Max(Bounds.Left, AvailableBounds.Left), AvailableBounds.Right - Width), 0)
		    Var Top As Integer = Max(Min(Max(Bounds.Top, AvailableBounds.Top), AvailableBounds.Bottom - Height), 0)
		    Self.Bounds = New Xojo.Rect(Left, Top, Width, Height)
		  End If
		  
		  #if TargetMacOS
		    Var Win As NSWindowMBS = Self.NSWindowMBS
		    Win.StyleMask = Win.StyleMask Or NSWindowMBS.NSFullSizeContentViewWindowMask
		    Win.TitlebarAppearsTransparent = True
		    Win.TitleVisibility = NSWindowMBS.NSWindowTitleHidden
		    
		    Var Toolbar As New NSToolbarMBS("com.thezaz.beacon.mainwindow.toolbar")
		    Toolbar.sizeMode = NSToolbarMBS.NSToolbarDisplayModeIconOnly
		    Toolbar.showsBaselineSeparator = False
		    Self.mToolbar = Toolbar
		    
		    Win.toolbar = Toolbar
		    
		    Var CloseButton As NSButtonMBS = Win.StandardWindowButton(NSWindowMBS.NSWindowCloseButton)
		    Var ZoomButton As NSButtonMBS = Win.StandardWindowButton(NSWindowMBS.NSWindowZoomButton)
		    If (CloseButton Is Nil Or ZoomButton Is Nil) = False Then
		      Self.NavBar.LeftPadding = CloseButton.Frame.MinX + ZoomButton.Frame.MaxX
		    End If
		  #endif
		  
		  NotificationKit.Watch(Self, App.Notification_UpdateFound, BeaconSubview.Notification_ViewShown)
		  Self.SetupUpdateUI()
		  
		  Self.mOpened = True
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  If Self.mOpened Then
		    Var Bounds As Xojo.Rect = Self.Bounds
		    Preferences.MainWindowPosition = New Rect(Bounds.Left, Bounds.Top, Bounds.Width, Bounds.Height)
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  #if TargetWin32
		    Self.LibraryPane1.Dismiss()
		  #endif
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			If Self.mCurrentView = Nil Then
			Self.Close
			Return True
			End If
			
			Call Self.DiscardView(Self.mCurrentView)
			
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewDashboard() As Boolean Handles ViewDashboard.Action
			Self.ShowView(Self.DashboardPane1)
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewDocuments() As Boolean Handles ViewDocuments.Action
			Self.LibraryPane1.ShowPage(LibraryPane.PaneDocuments)
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewEngrams() As Boolean Handles ViewEngrams.Action
			Self.LibraryPane1.ShowPage(LibraryPane.PaneEngrams)
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewPresets() As Boolean Handles ViewPresets.Action
			Self.LibraryPane1.ShowPage(LibraryPane.PanePresets)
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewSearch() As Boolean Handles ViewSearch.Action
			Self.LibraryPane1.ShowPage(LibraryPane.PaneSearch)
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ViewTools() As Boolean Handles ViewTools.Action
			Self.LibraryPane1.ShowPage(LibraryPane.PaneTools)
			Return True
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub AnimationStep(Identifier As String, Value As Double)
		  // Part of the AnimationKit.ValueAnimator interface.
		  
		  Select Case Identifier
		  Case "overlay_opacity"
		    Self.mOverlayFillOpacity = Value
		    Self.OverlayCanvas.Invalidate
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  #if TargetMacOS
		    Self.mObserver = New NSNotificationObserverMBS
		    AddHandler mObserver.GotNotification, WeakAddressOf mObserver_GotNotification
		    
		    NSNotificationCenterMBS.DefaultCenter.AddObserver(Self.mObserver, NSWindowMBS.NSWindowWillEnterFullScreenNotification)
		    NSNotificationCenterMBS.DefaultCenter.addObserver(Self.mObserver, NSWindowMBS.NSWindowDidExitFullScreenNotification)
		  #endif
		  
		  Super.Constructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrentView() As BeaconSubview
		  Return Self.mCurrentView
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DiscardView(View As BeaconSubview) As Boolean
		  If View = DashboardPane1 Then
		    Return False
		  End If
		  
		  If Not View.ConfirmClose(AddressOf ShowView) Then
		    Return False
		  End If
		  
		  If View = Self.mCurrentView Then
		    Self.ShowView(Nil)
		  End If
		  
		  Var ViewIndex As Integer = Self.mSubviews.IndexOf(View)
		  If ViewIndex = -1 Then
		    Return True
		  End If
		  
		  View.AddObserver(Self, "ToolbarCaption")
		  View.AddObserver(Self, "ToolbarIcon")
		  
		  Self.mSubviews.RemoveRowAt(ViewIndex)
		  View.Close
		  Self.TabBar1.Count = Self.mSubviews.LastRowIndex + 2
		  Self.LibraryPane1.CleanupClosedViews()
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Documents(SwitchTo As Boolean = True) As DocumentsComponent
		  If SwitchTo Then
		    Self.SwitchView(Self.PageDocuments)
		  End If
		  
		  Return Self.DocumentsComponent1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FrontmostDocumentView() As DocumentEditorView
		  If (Self.mCurrentView Is Nil) = False And Self.mCurrentView IsA DocumentEditorView Then
		    Return DocumentEditorView(Self.mCurrentView)
		  End If
		  
		  For Each View As BeaconSubview In Self.mSubviews
		    If (View Is Nil) = False And View IsA DocumentEditorView Then
		      Return DocumentEditorView(View)
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mObserver_GotNotification(Sender As NSNotificationObserverMBS, Notification As NSNotificationMBS)
		  #Pragma Unused Sender
		  
		  If Notification Is Nil Then
		    Return
		  End If
		  
		  Select Case Notification.Name
		  Case NSWindowMBS.NSWindowWillEnterFullScreenNotification
		    Self.NSWindowMBS.Toolbar = Nil
		    Self.NavBar.LeftPadding = -1
		  Case NSWindowMBS.NSWindowDidExitFullScreenNotification
		    Self.NSWindowMBS.Toolbar = Self.mToolbar
		    
		    Var CloseButton As NSButtonMBS = Self.NSWindowMBS.StandardWindowButton(NSWindowMBS.NSWindowCloseButton)
		    Var ZoomButton As NSButtonMBS = Self.NSWindowMBS.StandardWindowButton(NSWindowMBS.NSWindowZoomButton)
		    If (CloseButton Is Nil Or ZoomButton Is Nil) = False Then
		      Self.NavBar.LeftPadding = CloseButton.Frame.MinX + ZoomButton.Frame.MaxX
		    End If
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mOverlayFillAnimation_Completed(Sender As AnimationKit.ValueTask)
		  #Pragma Unused Sender
		  
		  Self.OverlayCanvas.Visible = False
		  #if TargetWin32
		    Self.Views.Visible = True
		    Self.TabBar1.Visible = True
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NotificationKit_NotificationReceived(Notification As NotificationKit.Notification)
		  // Part of the NotificationKit.Receiver interface.
		  
		  Select Case Notification.Name
		  Case App.Notification_UpdateFound
		    Self.SetupUpdateUI()
		  Case BeaconSubview.Notification_ViewShown
		    Self.UpdateEditorMenu()
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObservedValueChanged(Source As ObservationKit.Observable, Key As String, Value As Variant)
		  // Part of the ObservationKit.Observer interface.
		  
		  #Pragma Unused Source
		  #Pragma Unused Value
		  
		  Select Case Key
		  Case "ToolbarCaption", "ToolbarIcon"
		    Self.TabBar1.Invalidate
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Presets() As LibraryPanePresets
		  Return Self.LibraryPane1.PresetsPane
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupUpdateUI()
		  If App.UpdateAvailable Then
		    Var Data As Dictionary = App.UpdateDetails
		    Var Preview As String = Data.Value("Preview")
		    If Preview.IsEmpty = False Then
		      Preview = Preview + " Click here to update."
		    Else
		      Preview = "Beacon " + Data.Value("Version") + " is now available! Click here to update."
		    End If
		    
		    Var UpdateItem As OmniBarItem = Self.NavBar.Item("NavUpdate")
		    If UpdateItem Is Nil Then
		      UpdateItem = OmniBarItem.CreateButton("NavUpdate", "", IconToolbarImport, Preview)
		      UpdateItem.AlwaysUseActiveColor = True
		      UpdateItem.ActiveColor = OmniBarItem.ActiveColors.Green
		      
		      Var Idx As Integer = Self.NavBar.IndexOf("NavUser")
		      If Idx > -1 Then
		        Self.NavBar.Insert(Idx, UpdateItem)
		      Else
		        Self.NavBar.Append(UpdateItem)
		      End If
		    Else
		      UpdateItem.HelpTag = Preview
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowLibraryPane(PageIndex As Integer)
		  Self.LibraryPane1.ShowPage(PageIndex)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowView(View As BeaconSubview)
		  If Self.mCurrentView = View Then
		    Return
		  End If
		  
		  If Self.mCurrentView <> Nil Then
		    Self.mCurrentView.Visible = False
		    Self.mCurrentView.SwitchedFrom()
		  End If
		  
		  If View = Nil Or View = DashboardPane1 Then
		    Self.Changed = False
		    Self.mCurrentView = Nil
		    Self.Views.SelectedPanelIndex = 0
		    Self.TabBar1.SelectedIndex = 0
		    Self.DashboardPane1.SwitchedTo()
		    Self.Title = "Beacon"
		    Self.UpdateEditorMenu()
		    Return
		  End If
		  
		  View.Visible = True
		  Self.mCurrentView = View
		  
		  Var ViewIndex As Integer = Self.mSubviews.IndexOf(View)
		  If ViewIndex = -1 Then
		    Self.mSubviews.AddRow(View)
		    ViewIndex = Self.mSubviews.LastRowIndex
		    Self.TabBar1.Count = Self.mSubviews.LastRowIndex + 2
		    View.EmbedWithinPanel(Self.Views, 1, 0, 0, Self.Views.Width, Self.Views.Height)
		    
		    View.AddObserver(Self, "ToolbarCaption")
		    View.AddObserver(Self, "ToolbarIcon")
		    
		    AddHandler View.OwnerModifiedHook, WeakAddressOf Subview_ContentsChanged
		  End If
		  Self.TabBar1.SelectedIndex = ViewIndex + 1
		  
		  Self.Changed = View.Changed
		  
		  If Self.mCurrentView.ToolbarCaption.Length > 0 Then
		    Self.Title = "Beacon: " + Self.mCurrentView.ToolbarCaption
		  Else
		    Self.Title = "Beacon"
		  End If
		  
		  Self.mCurrentView.SwitchedTo()
		  Self.Views.SelectedPanelIndex = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Subview_ContentsChanged(Sender As ContainerControl)
		  If Self.mCurrentView = Sender Then
		    Self.Changed = Sender.Changed
		    If Self.mCurrentView.ToolbarCaption.Length > 0 Then
		      Self.Title = "Beacon: " + Self.mCurrentView.ToolbarCaption
		    Else
		      Self.Title = "Beacon"
		    End If
		  End If
		  Self.TabBar1.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SwitchView(Index As Integer)
		  Var CurrentIndex As Integer = Self.Pages.SelectedPanelIndex
		  If CurrentIndex = Index Then
		    Return
		  End If
		  
		  Select Case CurrentIndex
		  Case Self.PageHome
		    Self.DashboardPane1.SwitchedFrom()
		  Case Self.PageDocuments
		    Self.DocumentsComponent1.SwitchedFrom()
		  Case Self.PageBlueprints
		    Self.BlueprintsComponent1.SwitchedFrom()
		  Case Self.PagePresets
		    
		  Case Self.PageHelp
		    
		  End Select
		  
		  Self.Pages.SelectedPanelIndex = Index
		  
		  Select Case Index
		  Case Self.PageHome
		    Self.DashboardPane1.SwitchedTo(Nil)
		  Case Self.PageDocuments
		    Self.DocumentsComponent1.SwitchedTo(Nil)
		  Case Self.PageBlueprints
		    Self.BlueprintsComponent1.SwitchedTo(Nil)
		  Case Self.PagePresets
		    
		  Case Self.PageHelp
		    If Self.mHelpLoaded = False Then
		      Self.HelpViewer.LoadURL(Beacon.WebURL("/help"))
		    End If
		  End Select
		  
		  For Idx As Integer = 0 To Self.NavBar.LastRowIndex
		    Self.NavBar.Item(Idx).Toggled = (Idx = Index)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Tools() As LibraryPaneTools
		  Return Self.LibraryPane1.ToolsPane
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateEditorMenu()
		  Var Menu As MenuItem = EditorMenu
		  
		  For I As Integer = Menu.LastRowIndex DownTo 0
		    If Menu.MenuAt(I) IsA ConfigGroupMenuItem Then
		      Exit For I
		    End If
		    Menu.RemoveMenuAt(I)
		  Next
		  
		  Var Items() As MenuItem
		  If Self.CurrentView <> Nil Then
		    Self.CurrentView.GetEditorMenuItems(Items)
		  End If
		  
		  If Items.LastRowIndex = -1 Then
		    Return
		  End If
		  
		  Menu.AddMenu(New MenuItem(MenuItem.TextSeparator))
		  
		  For Each Item As MenuItem In Items
		    Menu.AddMenu(Item)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ViewAtIndex(Idx As Integer) As BeaconSubview
		  Return Self.mSubviews(Idx)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ViewCount() As UInteger
		  Return Self.mSubviews.LastRowIndex + 1
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrentView As BeaconSubview
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHelpLoaded As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLibraryPaneAnimation As AnimationKit.MoveTask
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObserver As NSNotificationObserverMBS
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOpened As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOverlayFillAnimation As AnimationKit.ValueTask
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOverlayFillOpacity As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOverlayPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubviews(-1) As BeaconSubview
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTabBarAnimation As AnimationKit.MoveTask
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mToolbar As NSToolbarMBS
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUpdateBarPressed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUpdateText As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mViewsAnimation As AnimationKit.MoveTask
	#tag EndProperty


	#tag Constant, Name = MinSplitterPosition, Type = Double, Dynamic = False, Default = \"300", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageBlueprints, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageDocuments, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageHelp, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageHome, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PagePresets, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events TabBar1
	#tag Event
		Sub Open()
		  Me.Count = 1
		End Sub
	#tag EndEvent
	#tag Event
		Function ViewAtIndex(TabIndex As Integer) As BeaconSubview
		  If TabIndex = 0 Then
		    Return DashboardPane1
		  Else
		    TabIndex = TabIndex - 1
		    If TabIndex >= 0 And TabIndex <= Self.mSubviews.LastRowIndex Then
		      Return Self.mSubviews(TabIndex)
		    End If
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Sub ShouldDismissView(ViewIndex As Integer)
		  If ViewIndex = 0 Then
		    Return
		  End If
		  
		  ViewIndex = ViewIndex - 1
		  If ViewIndex <= Self.mSubviews.LastRowIndex Then
		    Call Self.DiscardView(Self.mSubviews(ViewIndex))
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub SwitchToView(ViewIndex As Integer)
		  If ViewIndex = 0 Then
		    Self.ShowView(DashboardPane1)
		    Return
		  End If
		  
		  ViewIndex = ViewIndex - 1
		  If ViewIndex <= Self.mSubviews.LastRowIndex Then
		    Self.ShowView(Self.mSubviews(ViewIndex))
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events OverlayCanvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #Pragma Unused Areas
		  
		  If Self.mOverlayPic <> Nil Then
		    G.DrawPicture(Self.mOverlayPic, 0, 0, G.Width, G.Height, 0, 0, Self.mOverlayPic.Width, Self.mOverlayPic.Height)
		  End If
		  
		  G.DrawingColor = SystemColors.ShadowColor.AtOpacity(Self.mOverlayFillOpacity)
		  G.FillRectangle(0, 0, G.Width, G.Height)
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  If X >= 0 And Y >= 0 And X <= Me.Width And Y <= Me.Height Then
		    Self.LibraryPane1.Dismiss
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  Me.Visible = False
		  Me.Left = 0
		  Me.Top = 0
		  Me.Width = Self.Width
		  Me.Height = Self.Height
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LibraryPane1
	#tag Event
		Sub ShouldShowView(View As BeaconSubview)
		  Self.ShowView(View)
		End Sub
	#tag EndEvent
	#tag Event
		Function ShouldDiscardView(View As BeaconSubview) As Boolean
		  Return Self.DiscardView(View)
		End Function
	#tag EndEvent
	#tag Event
		Sub ChangePosition(Difference As Integer)
		  If Self.mLibraryPaneAnimation <> Nil Then
		    Self.mLibraryPaneAnimation.Cancel
		    Self.mLibraryPaneAnimation = Nil
		  End If
		  
		  Self.mLibraryPaneAnimation = New AnimationKit.MoveTask(Me)
		  Self.mLibraryPaneAnimation.Left = Me.Left + Difference
		  Self.mLibraryPaneAnimation.Curve = AnimationKit.Curve.CreateEaseOut
		  Self.mLibraryPaneAnimation.DurationInSeconds = 0.12
		  Self.mLibraryPaneAnimation.Run
		  
		  If Self.mOverlayFillAnimation <> Nil Then
		    Self.mOverlayFillAnimation.Cancel
		    Self.mOverlayFillAnimation = Nil
		  End If
		  
		  If Self.mOverlayFillOpacity = 0 Then
		    Self.mOverlayPic = Self.Capture
		  End If
		  
		  If Difference > 0 Then
		    Self.OverlayCanvas.Visible = True
		    #if TargetWin32
		      Self.Views.Visible = False
		      Self.TabBar1.Visible = False
		    #endif
		    Self.mOverlayFillAnimation = New AnimationKit.ValueTask(Self, "overlay_opacity", Self.mOverlayFillOpacity, 0.35)
		  Else
		    Self.mOverlayFillAnimation = New AnimationKit.ValueTask(Self, "overlay_opacity", Self.mOverlayFillOpacity, 0.0)
		    AddHandler Self.mOverlayFillAnimation.Completed, WeakAddressOf mOverlayFillAnimation_Completed
		  End If
		  
		  Self.mOverlayFillAnimation.Curve = Self.mLibraryPaneAnimation.Curve
		  Self.mOverlayFillAnimation.DurationInSeconds = Self.mLibraryPaneAnimation.DurationInSeconds
		  Self.mOverlayFillAnimation.Run
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events NavBar
	#tag Event
		Sub Open()
		  Var Home As OmniBarItem = OmniBarItem.CreateTab("NavHome", "Home")
		  Home.Toggled = True
		  Self.DashboardPane1.LinkedOmniBarItem = Home
		  
		  Var Documents As OmniBarItem = OmniBarItem.CreateTab("NavDocuments", "Documents")
		  Self.DocumentsComponent1.LinkedOmniBarItem = Documents
		  
		  Var Blueprints As OmniBarItem = OmniBarItem.CreateTab("NavBlueprints", "Blueprints")
		  Self.BlueprintsComponent1.LinkedOmniBarItem = Blueprints
		  
		  Var Presets As OmniBarItem = OmniBarItem.CreateTab("NavPresets", "Presets")
		  
		  Var Help As OmniBarItem = OmniBarItem.CreateTab("NavHelp", "Help")
		  
		  Var User As OmniBarItem = OmniBarItem.CreateButton("NavUser", "", IconToolbarUser, "Access user settings")
		  
		  Me.Append(Home, Documents, Blueprints, Presets, Help, OmniBarItem.CreateFlexibleSpace, User)
		End Sub
	#tag EndEvent
	#tag Event
		Sub ItemPressed(Item As OmniBarItem, ItemRect As Rect)
		  Var NewIndex As Integer
		  Select Case Item.Name
		  Case "NavDocuments"
		    NewIndex = Self.PageDocuments
		  Case "NavBlueprints"
		    NewIndex = Self.PageBlueprints
		  Case "NavPresets"
		    NewIndex = Self.PagePresets
		  Case "NavHelp"
		    NewIndex = Self.PageHelp
		  Case "NavHome"
		    NewIndex = Self.PageHome
		  Case "NavUpdate"
		    Call App.HandleURL("beacon://action/checkforupdate")
		    Return
		  Else
		    Return
		  End Select
		  
		  Self.SwitchView(NewIndex)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events HelpViewer
	#tag Event
		Sub DocumentComplete(url as String)
		  #Pragma Unused URL
		  
		  Self.NavBar.Item("NavHelp").HasProgressIndicator = False
		  Self.mHelpLoaded = True
		End Sub
	#tag EndEvent
	#tag Event
		Sub DocumentProgressChanged(URL as String, percentageComplete as Integer)
		  #Pragma Unused URL
		  
		  Self.NavBar.Item("NavHelp").Progress = PercentageComplete
		End Sub
	#tag EndEvent
	#tag Event
		Sub DocumentBegin(url as String)
		  #Pragma Unused URL
		  
		  Var Item As OmniBarItem = Self.NavBar.Item("NavHelp")
		  Item.HasProgressIndicator = True
		  Item.Progress = OmniBarItem.ProgressIndeterminate
		End Sub
	#tag EndEvent
	#tag Event
		Function CancelLoad(URL as String) As Boolean
		  Static TicketURL As String
		  If TicketURL.IsEmpty Then
		    TicketURL = Beacon.WebURL("/help/contact")
		  End If
		  If URL = TicketURL Then
		    App.StartTicket()
		    Return True
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events DashboardPane1
	#tag Event
		Sub NewDocument()
		  Self.SwitchView(Self.PageDocuments)
		  Self.DocumentsComponent1.NewDocument()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Resizeable"
		Visible=false
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
