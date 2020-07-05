#tag Window
Begin BeaconPagedSubview DocumentsComponent
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
   Height          =   570
   InitialParent   =   ""
   Left            =   0
   LockBottom      =   True
   LockLeft        =   True
   LockRight       =   True
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Tooltip         =   ""
   Top             =   0
   Transparent     =   True
   Visible         =   True
   Width           =   896
   Begin OmniBar Nav
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
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Visible         =   True
      Width           =   896
   End
   Begin PagePanel Views
      AllowAutoDeactivate=   True
      Enabled         =   True
      Height          =   532
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelCount      =   3
      Panels          =   ""
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   38
      Transparent     =   False
      Value           =   0
      Visible         =   True
      Width           =   896
      Begin RecentDocumentsComponent RecentDocumentsComponent1
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
         Height          =   532
         InitialParent   =   "Views"
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
         Tooltip         =   ""
         Top             =   38
         Transparent     =   True
         Visible         =   True
         Width           =   896
      End
      Begin CloudDocumentsComponent CloudDocumentsComponent1
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
         Height          =   532
         InitialParent   =   "Views"
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
         Width           =   896
      End
      Begin CommunityDocumentsComponent CommunityDocumentsComponent1
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
         Height          =   532
         InitialParent   =   "Views"
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
         Width           =   896
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Self.AppendPage(Self.RecentDocumentsComponent1)
		  Self.AppendPage(Self.CloudDocumentsComponent1)
		  Self.AppendPage(Self.CommunityDocumentsComponent1)
		End Sub
	#tag EndEvent

	#tag Event
		Sub PageChanged(OldIndex As Integer, NewIndex As Integer)
		  If OldIndex > -1 Then
		    Self.Nav.Item(OldIndex).Toggled = False
		  End If
		  
		  If NewIndex > -1 Then
		    Self.Nav.Item(NewIndex).Toggled = True
		  End If
		  
		  Self.Views.SelectedPanelIndex = NewIndex
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AttachControllerEvents(Controller As Beacon.DocumentController)
		  AddHandler Controller.Loaded, WeakAddressOf Controller_Loaded
		  AddHandler Controller.LoadError, WeakAddressOf Controller_LoadError
		  AddHandler Controller.LoadProgress, WeakAddressOf Controller_LoadProgress
		  AddHandler Controller.LoadStarted, WeakAddressOf Controller_LoadStarted
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Controller_Loaded(Sender As Beacon.DocumentController, Document As Beacon.Document)
		  #Pragma Unused Document
		  
		  Self.DetachControllerEvents(Sender)
		  
		  #if false
		    Var URL As Beacon.DocumentURL = Sender.URL
		    Select Case URL.Scheme
		    Case Beacon.DocumentURL.TypeLocal, Beacon.DocumentURL.TypeTransient
		      Self.View = Self.ViewRecentDocuments
		    Case Beacon.DocumentURL.TypeCloud
		      Self.View = Self.ViewCloudDocuments
		    Case Beacon.DocumentURL.TypeWeb
		      Self.View = Self.ViewCommunityDocuments
		    End Select
		    Self.SelectDocument(URL)
		  #endif
		  
		  Var View As New DocumentEditorView(Sender)
		  View.Changed = Sender.Document.Modified
		  View.LinkedOmniBarItem = Self.Nav.Item(Sender.URL.Hash)
		  View.LinkedOmniBarItem.CanBeClosed = True
		  View.LinkedOmniBarItem.HasUnsavedChanges = View.Changed
		  
		  Self.Views.AddPanel
		  Var PanelIndex As Integer = Self.Views.LastAddedPanelIndex
		  View.EmbedWithinPanel(Self.Views, PanelIndex, 0, 0, Self.Views.Width, Self.Views.Height)
		  
		  Self.AppendPage(View)
		  Self.CurrentPage = View
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Controller_LoadError(Sender As Beacon.DocumentController, Reason As String)
		  #Pragma Unused Reason
		  
		  Self.DetachControllerEvents(Sender)
		  
		  Var NavItem As OmniBarItem = Self.Nav.Item(Sender.URL.Hash)
		  If (NavItem Is Nil) = False Then
		    Self.Nav.Remove(NavItem)
		  End If
		  
		  Var RecentIdx As Integer = -1
		  Var Recents() As Beacon.DocumentURL = Preferences.RecentDocuments
		  For I As Integer = 0 To Recents.LastRowIndex
		    If Recents(I) = Sender.URL Then
		      RecentIdx = I
		      Exit For I
		    End If
		  Next
		  
		  If RecentIdx > -1 Then
		    If Self.ShowConfirm("Unable to load """ + Sender.Name + """", "The document could not be loaded. It may have been deleted. Would you like to remove it from the recent documents list?", "Remove", "Keep") Then
		      Recents.RemoveRowAt(RecentIdx)
		      Preferences.RecentDocuments = Recents
		    End If
		  Else
		    Self.ShowAlert("Unable to load """ + Sender.Name + """", "The document could not be loaded. It may have been deleted.")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Controller_LoadProgress(Sender As Beacon.DocumentController, BytesReceived As Int64, BytesTotal As Int64)
		  #Pragma Unused Sender
		  
		  Var NavItem As OmniBarItem = Self.Nav.Item(Sender.URL.Hash)
		  If (NavItem Is Nil) = False Then
		    NavItem.Progress = BytesReceived / BytesTotal
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Controller_LoadStarted(Sender As Beacon.DocumentController)
		  Var NavItem As OmniBarItem = Self.Nav.Item(Sender.URL.Hash)
		  If NavItem Is Nil Then
		    Return
		  End If
		  
		  NavItem.HasProgressIndicator = True
		  NavItem.Progress = OmniBarItem.ProgressIndeterminate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DetachControllerEvents(Controller As Beacon.DocumentController)
		  RemoveHandler Controller.Loaded, WeakAddressOf Controller_Loaded
		  RemoveHandler Controller.LoadError, WeakAddressOf Controller_LoadError
		  RemoveHandler Controller.LoadProgress, WeakAddressOf Controller_LoadProgress
		  RemoveHandler Controller.LoadStarted, WeakAddressOf Controller_LoadStarted
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImportFile(File As FolderItem)
		  Call DocumentImportWindow.Present(WeakAddressOf LoadImportedDocuments, New Beacon.Document, File)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadImportedDocuments(Documents() As Beacon.Document)
		  For Each Document As Beacon.Document In Documents
		    Self.NewDocument(Document)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewDocument(Document As Beacon.Document = Nil)
		  If Document Is Nil Then
		    Document = New Beacon.Document
		    
		    Static NewDocumentNumber As Integer = 1
		    Document.Title = "Untitled Document " + NewDocumentNumber.ToString
		    Document.Modified = False
		    NewDocumentNumber = NewDocumentNumber + 1
		  End If
		  
		  Var Controller As New Beacon.DocumentController(Document, App.IdentityManager.CurrentIdentity)
		  Var NavItem As New OmniBarItem(Controller.URL.Hash, Controller.Name)
		  Self.Nav.Append(NavItem)
		  
		  Self.AttachControllerEvents(Controller)
		  
		  Controller.Load()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OpenDocument(URL As Beacon.DocumentURL, AddToRecents As Boolean = True)
		  Var Hash As String = URL.Hash
		  Var NavItem As OmniBarItem = Self.Nav.Item(Hash)
		  If (NavItem Is Nil) = False Then
		    // We've already started loading this item
		    For Idx As Integer = 0 To Self.LastPageIndex
		      Var Page As BeaconSubview = Self.Page(Idx)
		      If Page.LinkedOmniBarItem = NavItem Then
		        Self.CurrentPageIndex = Idx
		        Return
		      End If
		    Next
		    
		    Return
		  End If
		  
		  Var Controller As New Beacon.DocumentController(URL, App.IdentityManager.CurrentIdentity)
		  NavItem = New OmniBarItem(Hash, Controller.Name)
		  Self.Nav.Append(NavItem)
		  
		  Self.AttachControllerEvents(Controller)
		  
		  Controller.Load()
		  
		  If AddToRecents Then
		    Preferences.AddToRecentDocuments(URL)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OpenDocument(File As FolderItem, AddToRecents As Boolean = True)
		  Var URL As Beacon.DocumentURL = Beacon.DocumentURL.URLForFile(New BookmarkedFolderItem(File))
		  Self.OpenDocument(URL, AddToRecents)
		End Sub
	#tag EndMethod


	#tag Constant, Name = PageCloud, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageCommunity, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageRecents, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events Nav
	#tag Event
		Sub Open()
		  Var Recents As New OmniBarItem("NavRecents", "Recents")
		  Var Cloud As New OmniBarItem("NavCloud", "Cloud")
		  Var Community As New OmniBarItem("NavCommunity", "Community")
		  
		  Recents.Toggled = True
		  
		  Me.Append(Recents, Cloud, Community)
		  
		  Self.RecentDocumentsComponent1.LinkedOmniBarItem = Recents
		  Self.CloudDocumentsComponent1.LinkedOmniBarItem = Cloud
		  Self.CommunityDocumentsComponent1.LinkedOmniBarItem = Community
		End Sub
	#tag EndEvent
	#tag Event
		Sub ItemPressed(Item As OmniBarItem)
		  For Idx As Integer = 0 To Self.LastPageIndex
		    Var Page As BeaconSubview = Self.Page(Idx)
		    If Page.LinkedOmniBarItem = Item Then
		      Self.CurrentPageIndex = Idx
		      Return
		    End If
		  Next
		End Sub
	#tag EndEvent
	#tag Event
		Sub ShouldCloseItem(Item As OmniBarItem)
		  Break
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events RecentDocumentsComponent1
	#tag Event
		Sub OpenDocument(URL As Beacon.DocumentURL)
		  Self.OpenDocument(URL)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CloudDocumentsComponent1
	#tag Event
		Sub OpenDocument(URL As Beacon.DocumentURL)
		  Self.OpenDocument(URL)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CommunityDocumentsComponent1
	#tag Event
		Sub OpenDocument(URL As Beacon.DocumentURL)
		  Self.OpenDocument(URL)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Behavior"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Behavior"
		InitialValue="300"
		Type="Integer"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="InitialParent"
		Visible=false
		Group="Position"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabPanelIndex"
		Visible=false
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabStop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Tooltip"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
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
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EraseBackground"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DoubleBuffer"
		Visible=true
		Group="Windows Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior