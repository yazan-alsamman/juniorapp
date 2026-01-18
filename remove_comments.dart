import 'dart:io';

void main() async {
  final currentDir = Directory.current.path;
  final directory = Directory('$currentDir/lib/lib_admin');
  if (!directory.existsSync()) {
    print('Directory not found: ${directory.path}');
    return;
  }
  await _processDirectory(directory);
  print('Done removing comments from all files.');
}

Future<void> _processDirectory(Directory dir) async {
  await for (var entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      await _removeCommentsFromFile(entity);
    }
  }
}

Future<void> _removeCommentsFromFile(File file) async {
  try {
    final content = await file.readAsString();
    final lines = content.split('\n');
    final newLines = <String>[];
    bool inMultiLineComment = false;
    
    for (var line in lines) {
      String processedLine = line;
      
      if (inMultiLineComment) {
        final endIndex = processedLine.indexOf('*/');
        if (endIndex != -1) {
          processedLine = processedLine.substring(endIndex + 2);
          inMultiLineComment = false;
        } else {
          processedLine = '';
        }
      }
      
      if (!inMultiLineComment) {
        // Remove single-line comments
        processedLine = processedLine.replaceAll(RegExp(r'//.*'), '');
        
        // Handle multi-line comments
        while (true) {
          final startIndex = processedLine.indexOf('/*');
          if (startIndex == -1) break;
          
          final endIndex = processedLine.indexOf('*/', startIndex + 2);
          if (endIndex != -1) {
            processedLine = processedLine.replaceRange(startIndex, endIndex + 2, '');
          } else {
            processedLine = processedLine.substring(0, startIndex);
            inMultiLineComment = true;
            break;
          }
        }
        
        // Remove documentation comments
        processedLine = processedLine.replaceAll(RegExp(r'///.*'), '');
      }
      
      if (processedLine.trim().isNotEmpty || line.trim().isEmpty) {
        newLines.add(processedLine);
      } else {
        // Keep empty lines to maintain structure
        newLines.add('');
      }
    }
    
    final newContent = newLines.join('\n');
    // Clean up multiple empty lines
    final cleanedContent = newContent.replaceAll(RegExp(r'\n\n\n+'), '\n\n');
    await file.writeAsString(cleanedContent);
  } catch (e) {
    print('Error processing ${file.path}: $e');
  }
}
