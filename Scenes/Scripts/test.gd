extends Node3D

func _ready():
	#print(IP.get_local_addresses())
	print(IP.resolve_hostname(str(OS.get_environment(OS.get_unique_id())),1))
