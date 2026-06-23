import os
from PIL import Image

def get_resample_filter():
    try:
        return Image.Resampling.LANCZOS
    except AttributeError:
        return Image.ANTIALIAS

def main():
    logo_path = os.path.abspath("../../monopol_logo.png")
    if not os.path.exists(logo_path):
        print(f"Error: logo not found at {logo_path}")
        return

    # Load logo
    img = Image.open(logo_path).convert("RGBA")
    
    # 1. Generate icon.png (1024x1024)
    # Background color #0A1931
    bg_color = (10, 25, 49, 255) # #0A1931
    icon = Image.new("RGBA", (1024, 1024), bg_color)
    
    # Crop the emblem (from x=0 to x=70)
    emblem = img.crop((0, 0, 70, 80))
    emblem_bbox = emblem.getbbox()
    if emblem_bbox:
        emblem = emblem.crop(emblem_bbox)
        
    # Resize emblem to fit in icon (e.g. max 512px height/width)
    emblem_w, emblem_h = emblem.size
    scale = min(512 / emblem_w, 512 / emblem_h)
    new_w = int(emblem_w * scale)
    new_h = int(emblem_h * scale)
    emblem_resized = emblem.resize((new_w, new_h), get_resample_filter())
    
    # Paste emblem into center of icon
    offset_x = (1024 - new_w) // 2
    offset_y = (1024 - new_h) // 2
    icon.paste(emblem_resized, (offset_x, offset_y), emblem_resized)
    
    icon_path = "assets/icon.png"
    icon.save(icon_path, "PNG")
    print(f"Generated {icon_path}")

    # 2. Generate splash.png (2732x2732)
    splash = Image.new("RGBA", (2732, 2732), bg_color)
    
    # Crop tight bounding box of full logo to avoid padding issues
    logo_bbox = img.getbbox()
    if logo_bbox:
        logo_cropped = img.crop(logo_bbox)
    else:
        logo_cropped = img
        
    logo_w, logo_h = logo_cropped.size
    # Resize logo to fit in splash (e.g. width of 1600px)
    target_width = 1600
    scale = target_width / logo_w
    new_w = int(logo_w * scale)
    new_h = int(logo_h * scale)
    logo_resized = logo_cropped.resize((new_w, new_h), get_resample_filter())
    
    # Paste logo into center of splash
    offset_x = (2732 - new_w) // 2
    offset_y = (2732 - new_h) // 2
    splash.paste(logo_resized, (offset_x, offset_y), logo_resized)
    
    splash_path = "assets/splash.png"
    splash.save(splash_path, "PNG")
    print(f"Generated {splash_path}")
    
    # Save as splash-dark too
    splash_dark_path = "assets/splash-dark.png"
    splash.save(splash_dark_path, "PNG")
    print(f"Generated {splash_dark_path}")

if __name__ == "__main__":
    main()
