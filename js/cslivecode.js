var cs;
var codigo;
const currentFilePath = "/temp.csd";
//const AudioContext_sr = new (window.AudioContext || window.webkitAudioContext)();
const fileManager = new FileManager(['csd'], 
        function(t) { console.debug(t); });

function evalCode() {
    var txt = codigo.replace(/##REPLACE_WITH_SCORE##/, 'f0 z\n' + editor.getValue() + '\n');
    fileManager.writeStringToFile(currentFilePath,
         txt);
     csound.stop();
     csound.Csound.setOption("-r" + csound.Csound.getaudioContext().sampleRate);
     csound.CompileCsdText(currentFilePath);
     csound.Play();

}


function renderCode() {
    var txt = codigo.replace(/##REPLACE_WITH_SCORE##/, editor.getValue() + '\n');
    fileManager.writeStringToFile(currentFilePath,
         txt);
    csound.stop();
    csound.Csound.render(currentFilePath);
    saveWav();
}


function saveWav(){
  csound.RequestFileFromLocal("test.wav");
  window.URL = window.webkitURL || window.URL;
  const MIME_TYPE = 'application/octet-stream';
  var bb = new Blob([csound.GetFileData()],{type: MIME_TYPE});
  var a = document.createElement('a'); 
  a.download =  "test.wav";
  a.href = window.URL.createObjectURL(bb);
  a.textContent = 'Click here to save file';
  a.dataset.downloadurl = [MIME_TYPE, a.download, a.href].join(':');
  a.id = "test1";
  document.body.appendChild(a);
  $('#test1')[0].click(); 
  document.body.removeChild(a);

}

function saveText(){
   var txt = editor.getValue();
   window.URL = window.webkitURL || window.URL;
   const MIME_TYPE = 'application/octet-stream';
   var myBlob = new Blob([txt], {type : MIME_TYPE});
   var a = document.createElement('a'); 
   a.download =  "mi_archivo.csd";
   a.href = window.URL.createObjectURL(myBlob);
   a.textContent = 'Click here to save file';
   a.dataset.downloadurl = [MIME_TYPE, a.download, a.href].join(':');
   a.id = "test1";
   document.body.appendChild(a);
   $('#test1')[0].click();
   document.body.removeChild(a);
     
}
 
 
let editor = CodeMirror.fromTextArea(
	document.getElementById("csoundCodeEditor"), 
	{
		lineNumbers: true,
        matchBrackets: true,
        autoCloseBrackets: true,
		theme: "monokai",
        mode: "csound",
        //keyMap: "vim",
		extraKeys: {
			"Ctrl-E": saveText,
		},
	});

var $wrapper = $(editor.getWrapperElement());
$wrapper.addClass('CodeMirror-absolute'); // hides cursor

function loadCsd(csdFile) {
  var client = new XMLHttpRequest();

  client.open('GET', csdFile, true);
  client.onreadystatechange = function() {
    codigo = client.responseText;
  }
  client.send();
}


function moduleDidLoad() 
{
    var ld = document.getElementById("loadDiv");
    if(csound.Csound.getaudioContext().state != "running") 
            {
		      if(ld != null)
		      {
                ld.innerHTML = "<b>C l i c k &nbsp;  p a r a &nbsp; I n g r e s a r . . .</b>";
                ld.addEventListener ("click", function() {
			    csound.Csound.getaudioContext().resume().then(() => {
						ld.style.display='none';
                        console.log('Playback resumed successfully');
                    });
                });
			  }
            } 
    else 
            {
                if(ld != null)
                    ld.style.display='none';
            }
}


$("#CompileButton").click(evalCode);
$("#ResetButton").click(function(){ 
     csound.stop();
     csound.started=false;
    });

$("#RenderButton").click(renderCode);
$("#SaveTextButton").click(saveText);

$('#dragbar').mousedown(function(e){
        e.preventDefault();
        $(document).mousemove(function(e){
	     var c = e.pageX / $('#editor-container').parent().outerWidth(true) * 100;

          $('#editor-container').css("width",c + '%');
          $('#dragbar').css("left",c + '%');
          var f = $('#editor-container').outerWidth(true) / $('#editor-container').parent().outerWidth(true) * 100;
          $('#lesson').css("width", (99 - f) + '%');
          //$('#lesson').css("left", f + '%');
          //$('.controls').css("width", (99 - f) + '%');
          //$('.controls').css("left", (f+0.2) + '%');
          AdjustIframeHeight();
        })
});

function AdjustIframeHeight() { 
	if($('#form-iframe').length) {
	   document.getElementById("form-iframe").style.height = document.getElementById("form-iframe").contentWindow.document.body.scrollHeight + "px"; 
   }
}

$(document).mouseup(function(e){
       $(document).unbind('mousemove');
});





