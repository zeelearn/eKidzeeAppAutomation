import 'dart:convert';

import 'package:encrypt/encrypt.dart';

import '../api/response/induction/teacher/induction_content_model.dart';

class MyEncryption {
  static decryptFile(ContentModule contentModule, inFile, outFile) async {
    ///String dir = (await getTemporaryDirectory()).path;
    try {
      String filename = contentModule.iPDContentName!;
      //File inFile = File('${dir}/${filename}.mp4');
      //File inFile = new File("videoenc.aes");
      //File outFile =  File('${dir}/${filename}_e.mp4');

      bool outFileExists = await outFile.exists();

      if (!outFileExists) {
        await outFile.create();
      }

      final videoFileContents = await inFile.readAsBytesSync();

      final key = Key.fromUtf8(contentModule.iPDContentDecryptionKey!);
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(key));

      final encryptedFile = Encrypted(videoFileContents);
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

      final decryptedBytes = latin1.encode(decrypted);
      await outFile.writeAsBytes(decryptedBytes);
    } catch (e) {
      //debugPrint(e.toString());
    }
    //debugPrint('Decrupted....');
  }
}
