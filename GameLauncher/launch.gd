extends Button

var exe_link = "https://onedrive.live.com/download?cid=A5DCFF7CEA0F109A&resid=A5DCFF7CEA0F109A%21363&authkey=ABo3iwEbzc0-YYM"
var version_link = "https://onedrive.live.com/download?cid=A5DCFF7CEA0F109A&resid=A5DCFF7CEA0F109A%21361&authkey=ANuoTFKcet_wR2Q"

var exe_path = "user://Escape_Room.exe"
var version_path = "user://version.txt"


var http_request: HTTPRequest

func _ready():
	_verify_gamefiles()
	self.disabled = true

func file_exists(path:String)->bool:
	var dir = Directory.new()
	return dir.file_exists(path)

func _verify_gamefiles():
	
	if(file_exists(exe_path) && file_exists(version_path)):
		_download_file(version_link,version_path,true)
	else:
		_check_integrity()

func _download_file(link:String, path:String, just_version:bool):
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	self.text = "Downloading " + str(path.get_file())
	http_request.connect("request_completed",self,"_install_file",[path,just_version])
	
	var error = http_request.request_raw(link)
	if error != OK:
		self.text = "Download Error: " + str(error)

func _install_file(_result, _response_code, _headers,body,path, just_version:bool):
	
	if just_version:
		var new_version = str(body.get_string_from_utf8())
		_compare_version(new_version)
		return
	
	var dir = Directory.new()
	dir.remove(path)
	
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_buffer(body)
	file.close()
	_check_integrity()

func _check_integrity():
	if !file_exists(exe_path):
		_download_file(exe_link, exe_path, false)
		print("no exe")
		return
	
	if !file_exists(version_path):
		_download_file(version_link, version_path, false)
		print("no version")
		return
		
	self.text = "Start Game"
	self.disabled = false
	

func _compare_version(new_version):
	var file = File.new()
	file.open(version_path,File.READ)
	var cur_version = file.get_as_text()
	file.close()
	if int(new_version) > int(cur_version):
		var dir = Directory.new()
		dir.remove(version_path)
	_check_integrity()


func _start_game():
	OS.shell_open(OS.get_user_data_dir() + "/Escape_Room.exe")


func _on_Button_pressed():
	_start_game()# Replace with function body.
