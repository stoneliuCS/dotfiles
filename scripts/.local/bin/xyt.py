from pathlib import Path
import shutil
import re

def list_all_songs(root_dir):
    """
    Recursively find and list all music files in a directory tree.
    
    Args:
        root_dir (str or pathlib.Path): The root directory to start searching from
    
    Returns:
        list: A list of all song file paths found
    """
    root_dir = Path(root_dir)
    
    music_extensions = ['.mp3', '.flac', '.m4a', '.wav', '.ogg', '.aac']
    
    songs = []
    for music_file in root_dir.glob('**/*'):
        if music_file.is_dir():
            continue
            
        if music_file.suffix.lower() in music_extensions:
            songs.append(music_file.stem)
    
    return songs

def normalize_string(text):
    """
    Normalize a string by removing special characters and converting to lowercase.
    This makes it easier to compare strings regardless of special characters.
    """
    if text is None:
        return ""
    
    # Remove special characters, replace with spaces
    normalized = re.sub(r'[^a-zA-Z0-9\s]', '', str(text))
    # Convert to lowercase
    normalized = normalized.lower()
    # Replace multiple spaces with single space
    normalized = re.sub(r'\s+', ' ', normalized)
    # Trim spaces
    normalized = normalized.strip()
    
    return normalized

if __name__ == "__main__":
    library = Path(
        "/Users/stoneliu/Music/Music/Media.localized/Automatically Add to Music.localized"
    )
    music = Path(
        "/Users/stoneliu/Music/Music/Media.localized/Music/"
    )
    songs = Path(__file__).parent / "songs"

    existing = set(map(normalize_string, list_all_songs(music)))
    existing |= set(map(normalize_string, list_all_songs(library)))

    for song in songs.iterdir():
        if song.name.startswith("."):
            continue
        if normalize_string(song.stem) in existing:
            print(f"Skipping duplicate: {song.name}")
            song.unlink()
        else:
            shutil.move(str(song), library / song.name)
            print(f"Added: {song.name}")
