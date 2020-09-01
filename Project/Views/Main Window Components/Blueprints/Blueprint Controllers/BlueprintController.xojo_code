#tag Class
Protected Class BlueprintController
	#tag Method, Flags = &h0
		Function AutoPublish() As Boolean
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Blueprint(ObjectID As String) As Beacon.Blueprint
		  If Self.mBlueprints.HasKey(ObjectID) Then
		    Return Self.mBlueprints.Value(ObjectID)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BlueprintCount() As Integer
		  Return Self.mBlueprints.KeyCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Blueprints() As Beacon.Blueprint()
		  Var Results() As Beacon.Blueprint
		  For Each Entry As DictionaryEntry In Self.mBlueprints
		    Results.AddRow(Entry.Value)
		  Next
		  Return Results
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CacheBlueprints(Blueprints() As Beacon.Blueprint)
		  Self.mBlueprints.RemoveAll
		  
		  For Each Blueprint As Beacon.Blueprint In Blueprints
		    Self.mBlueprints.Value(Blueprint.ObjectID.StringValue) = Blueprint
		  Next
		  
		  Self.mOriginalBlueprints = Self.mBlueprints.Clone
		  
		  Self.mLoading = False
		  RaiseEvent BlueprintsLoaded()
		  RaiseEvent WorkFinished()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.mBlueprints = New Dictionary
		  Self.mBlueprintsToSave = New Dictionary
		  Self.mBlueprintsToDelete = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Creatures() As Beacon.Creature()
		  Var Results() As Beacon.Creature
		  For Each Entry As DictionaryEntry In Self.mBlueprints
		    If Entry.Value IsA Beacon.Creature Then
		      Results.AddRow(Entry.Value)
		    End If
		  Next
		  Return Results
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteBlueprint(ParamArray Blueprints() As Beacon.Blueprint)
		  Self.DeleteBlueprints(Blueprints)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteBlueprints(Blueprints() As Beacon.Blueprint)
		  If Self.IsWorking Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Another action is already running"
		    Raise Err
		  End If
		  
		  For Each Blueprint As Beacon.Blueprint In Blueprints
		    Var ObjectID As String = Blueprint.ObjectID
		    
		    If Self.mBlueprints.HasKey(ObjectID) Then
		      Self.mBlueprints.Remove(ObjectID)
		    End If
		    If Self.mBlueprintsToSave.HasKey(ObjectID) Then
		      Self.mBlueprintsToSave.Remove(ObjectID)
		    End If
		    
		    Self.mBlueprintsToDelete.Value(ObjectID) = Blueprint
		  Next
		  
		  If Self.AutoPublish Then
		    Self.Publish()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DiscardChanges()
		  If Self.IsWorking Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Another action is already running"
		    Raise Err
		  End If
		  
		  If Self.mOriginalBlueprints Is Nil Then
		    Self.mBlueprints = New Dictionary
		  Else
		    Self.mBlueprints = Self.mOriginalBlueprints.Clone
		  End If
		  Self.mBlueprintsToSave = New Dictionary
		  Self.mBlueprintsToDelete = New Dictionary
		  
		  Self.LoadBlueprints()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Engrams() As Beacon.Engram()
		  Var Results() As Beacon.Engram
		  For Each Entry As DictionaryEntry In Self.mBlueprints
		    If Entry.Value IsA Beacon.Engram Then
		      Results.AddRow(Entry.Value)
		    End If
		  Next
		  Return Results
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub FinishPublishing(Success As Boolean, ErrorMessage As String)
		  Self.mPublishing = False
		  
		  If Success Then
		    Self.mBlueprintsToSave = New Dictionary
		    Self.mBlueprintsToDelete = New Dictionary
		  End If
		  
		  RaiseEvent WorkFinished()
		  RaiseEvent PublishFinished(Success, ErrorMessage)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasUnpublishedChanges() As Boolean
		  Return Self.mBlueprintsToSave.KeyCount > 0 Or Self.mBlueprintsToDelete.KeyCount > 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadBlueprints()
		  If Self.IsWorking Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Another action is already running"
		    Raise Err
		  End If
		  
		  Self.mLoading = True
		  
		  RaiseEvent WorkStarted()
		  
		  If IsEventImplemented("RefreshBlueprints") Then
		    RaiseEvent RefreshBlueprints()
		  Else
		    Var Blueprints() As Beacon.Blueprint
		    Self.CacheBlueprints(Blueprints)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Publish()
		  If Self.IsWorking Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Another action is already running"
		    Raise Err
		  End If
		  
		  Self.mPublishing = True
		  
		  RaiseEvent WorkStarted()
		  
		  If IsEventImplemented("Publish") Then 
		    Var BlueprintsToSave(), BlueprintsToDelete() As Beacon.Blueprint
		    For Each Entry As DictionaryEntry In Self.mBlueprintsToSave
		      BlueprintsToSave.AddRow(Entry.Value)
		    Next
		    For Each Entry As DictionaryEntry In Self.mBlueprintsToDelete
		      BlueprintsToDelete.AddRow(Entry.Value)
		    Next
		    
		    RaiseEvent Publish(BlueprintsToSave, BlueprintsToDelete)
		  Else
		    Self.FinishPublishing(False, "The code to perform this action is unfinished.")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveBlueprint(Blueprint As Beacon.Blueprint)
		  If Self.IsWorking Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Another action is already running"
		    Raise Err
		  End If
		  
		  Var ObjectID As String = Blueprint.ObjectID
		  
		  Self.mBlueprints.Value(ObjectID) = Blueprint
		  Self.mBlueprintsToSave.Value(ObjectID) = Blueprint
		  
		  If Self.mBlueprintsToDelete.HasKey(ObjectID) Then
		    Self.mBlueprintsToDelete.Remove(ObjectID)
		  End If
		  
		  If Self.AutoPublish Then
		    Self.Publish()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SpawnPoints() As Beacon.SpawnPoint()
		  Var Results() As Beacon.SpawnPoint
		  For Each Entry As DictionaryEntry In Self.mBlueprints
		    If Entry.Value IsA Beacon.SpawnPoint Then
		      Results.AddRow(Entry.Value)
		    End If
		  Next
		  Return Results
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event BlueprintsLoaded()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Publish(BlueprintsToSave() As Beacon.Blueprint, BlueprintsToDelete() As Beacon.Blueprint)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PublishFinished(Success As Boolean, Reason As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event RefreshBlueprints()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event WorkFinished()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event WorkStarted()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mLoading
			End Get
		#tag EndGetter
		IsLoading As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mPublishing
			End Get
		#tag EndGetter
		IsPublishing As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mLoading Or Self.mPublishing
			End Get
		#tag EndGetter
		IsWorking As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBlueprints As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBlueprintsToDelete As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBlueprintsToSave As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoading As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalBlueprints As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPublishing As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="IsLoading"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPublishing"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWorking"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass