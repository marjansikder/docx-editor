class FontLoader {
  // Load the list of all fonts (e.g., from your assets or Google Fonts)
  List<String> allFonts() {
    return [
      'Roboto',
      'OpenSans',
      // Add more font families here as needed
    ];
  }

  // Get the font file path based on the font family and style (bold, italic)
  Future<String?> getFontByName({required String fontFamily, bool bold = false, bool italic = false}) async {
    String fontStyle = '';
    if (bold) fontStyle += '-Bold';
    if (italic) fontStyle += '-Italic';

    String fontFileName = '$fontFamily$fontStyle.ttf';

    // Check if the font file exists in the assets and return its path
    if (await _fontFileExists(fontFileName)) {
      return 'assets/fonts/$fontFileName';
    }

    // Return null if the font file doesn't exist
    return null;
  }

  // Check if a font file exists in assets (you can enhance this if needed)
  Future<bool> _fontFileExists(String fontFileName) async {
    // Here you can check if the font file exists locally
    // This is a placeholder, you may need to adjust it for your project
    return true; // For simplicity, we're assuming the file exists
  }
}
