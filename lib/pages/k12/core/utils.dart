import 'dart:io';

import 'package:ekidzee/api/response/pentemind/learninggoals/uploadimage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/APIService.dart';
import '../../../constants.dart';

class Utils {
  static final tabselectedColor = kPrimaryLightColor;
  static final tabindicatorColor = kPrimaryLightColor;
  static final tabunselectedColor = Colors.grey;

  static String loadVimeoPlayer(String videoId, bool isPip, {int? seconds}) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://player.vimeo.com/api/player.js"></script>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
          
  <style>
  body {
      margin: 0; /* Remove any default margins */
      padding: 0; /* Remove any default padding */
      overflow: hidden; /* Prevent scrollbars */
      position: relative; /* For custom PiP button positioning */
    }

    iframe {
      display: block; /* Remove inline spacing */
      width: 100%; /* Make the iframe occupy full width */
      height: 100%; /* Make the iframe occupy full height */
      border: none; /* Remove iframe borders */
    }

    /* Custom PiP button - positioned above the player */
    #custom-pip-button {
      position: absolute; 
      bottom: 40px; /* Position it close to the top of the player */ 
      right: 2%;  /* Center the button horizontally */ 
      transform: translateX(-00%); /* Adjust for perfect centering */ 
      background-color: rgba(0, 0, 0, 0.7); 
      color: white; 
      padding: 5px 5px; 
      border: none; 
      border-radius: 5px; 
      font-size: 2px; /* Larger icon size */ 
      cursor: pointer; 
      z-index: 10; /* Make sure the button stays on top of the player */
      opacity: 1; /* Ensure the button is visible initially */
      transition: opacity 0.5s ease; /* Fade out smoothly */
    }

    #custom-pip-button:hover {
      background-color: rgba(0, 0, 0, 0.9);
    }

    /* Font Awesome Icon for PiP */
    #custom-pip-button i {
      font-size: 20px; /* Set icon size */
    }

              /* Increase the size of Vimeo player controls */
              .vp-controls__button {
                transform: scale(1.5); /* Scale up the buttons */
              }

              .vp-controls {
                height: auto; /* Ensure controls scale properly */
                margin: 0;

              }

              .vp-controls__wrapper {
                padding: 10px; /* Add padding for better spacing */
              }   

                 
  </style>
      </head>
      <body style="background-color: black; margin: 0; padding: 0; display: flex; align-items: center; justify-content: center; height: 100vh; width: 100vw; overflow: hidden;">
        <div style="width: 100%; height: 0; padding-bottom: 56.25%; position: relative;">
          <iframe id="vimeo-player" 
                  src="https://player.vimeo.com/video/$videoId?api=1&autoplay=1&controls=1&portrait=0&muted=0&byline=0&pip=${!kIsWeb && Platform.isAndroid ? '0' : '1'}#t=${seconds ?? 0}s"  
                  frameborder="0"
                  allow="autoplay; fullscreen; picture-in-picture"
                  allowfullscreen 
                  webkitallowfullscreen 
                  mozallowfullscreen
                  style="position:absolute;top:0;left:0;width:100%;height:100%;"></iframe>
        </div>
                       <button id="custom-pip-button">
      <!-- Font Awesome PiP icon -->
      <i class="fas fa-tv"></i>
    </button>
        <script>
          var player = new Vimeo.Player('vimeo-player');


          player.getDuration().then(function(duration) {
          if($kIsWeb){
          window.parent.postMessage(JSON.stringify({
          totalduration: duration}), "*");
          }else{
            window.flutter_inappwebview.callHandler('getDuration', duration);
          }
          });

          if($isPip) {
          document.getElementById('custom-pip-button').style.opacity = 0; 
          }

           document.getElementById('custom-pip-button').addEventListener('click', function() {
        window.flutter_inappwebview.callHandler('buttonClick', 'pip');
        document.getElementById('custom-pip-button').style.opacity = 0; // Hide button smoothly

    });

          document.getElementById('vimeo-player').addEventListener('click', function() {
      document.getElementById('custom-pip-button').style.opacity = 1; // Show button
    });

    // Hide the PiP button after 3 seconds when the page is first loaded
    // setTimeout(function() {
    //   document.getElementById('custom-pip-button').style.opacity = 0; // Hide the button initially after a delay
    // }, 3000); 

          // Send progress updates to Flutter
          player.on('timeupdate', function(data) {          
            console.log("Progress data:", data);
            if($kIsWeb){
          window.parent.postMessage(JSON.stringify({data}), "*");
          }else{
            window.flutter_inappwebview.callHandler('onProgress', JSON.stringify(data));
            }
          });

             player.on('play', function() {
             if(!$isPip) {
             document.getElementById('custom-pip-button').style.opacity = 1;
             setTimeout(function() {
                document.getElementById('custom-pip-button').style.opacity = 0; // Hide the button initially after a delay
            }, 5000); }
                window.flutter_inappwebview.callHandler('buttonClick', 'play');
              });

              player.on('pause', function() {
                window.flutter_inappwebview.callHandler('buttonClick', 'pause');
              });

           function pauseVideo() {
            player.pause();
           }

          window.addEventListener("message", function(event) {
    if (event.data && event.data.type === "flutterToJs") {
    console.log("Seeked to:", seconds);
      seekToTime(event.data.message);
    }
  });

          // Seek function
          function seekToTime(seconds) {
            player.setCurrentTime(seconds).then(function(seconds) {
              console.log("Seeked to:", seconds);
            }).catch(function(error) {
              console.error("Seek error:", error);
            });
          }
        </script>
      </body>
      </html>
    ''';
  }

  static Future<UploadImageResponse?> showImagePicker(
    BuildContext context,
  ) async {
    ImageSource? source;

    setImageSource(ImageSource? imageSource) {
      source = imageSource;
      Navigator.pop(context);
    }

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        if (kIsWeb) {
          setImageSource(ImageSource.gallery);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    setImageSource(null);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.redAccent,
                  )),
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () {
                setImageSource(ImageSource.camera);
              },
            ),
            ListTile(
              title: Text('Gallery'),
              onTap: () {
                setImageSource(ImageSource.gallery);
              },
            )
          ],
        );
      },
    );

    if (source == null) return null;

    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.gallery || source == ImageSource.camera) {
      XFile? photo;
      photo = await picker.pickImage(source: source!, imageQuality: 72);
      if (photo != null) {
        showDialog(
          context: context,
          builder: (context) => Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
        var response = await APIService().uploadImage(
          '',
          photo,
        );
        Navigator.pop(context);
        debugPrint('Utils image response is - $response');

        return response;
      }
    } else {
//       debugPrint('image not found');
      return null;
    }
    return null;
  }
}
