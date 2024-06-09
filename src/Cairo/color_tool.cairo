%lang starknet

from starkware.cairo.common.math import sqrt
//felt = uint
struct Image:
    width: felt
    height: felt
    pixels_bk: felt*
    hsi: (felt*, felt*, felt*)
   // המטרה של קוד זה היא להמיר את נתוני הפיקסלים של תמונה ממרחב הצבע 
   //RGB למרחב הצבע HSI (גוון, רוויה, עוצמה).
fu normalize_rgb_value(r: felt, g: felt, b: felt) -> (felt, felt, felt):
//מחלקים את הכל ב 255כי רוצים שתמיד יהיה בטווח בין 1-0
    let r_norm = r / 255
    let g_norm = g / 255
    let b_norm = b / 255
    return (r_norm, g_norm, b_norm)

    
fn rgb_to_hsi(image: Image):
  //  חשב גוון: הגוון מחושב על סמך הערכים היחסיים של הערוצים האדומים, הירוקים והכחולים. הנוסחה המשמשת מבטיחה שערך הגוון מייצג את הצבע הדומיננטי של הפיקסל.
  // חשב רוויה: הרוויה מחושבת כמדד לכמה הצבע שונה מתמונה בגווני אפור באותה עוצמה. זה מעיד על טוהר הצבע.
  // RGB המנורמלים ומייצגת את בהירות הפיקסל.
  //חשב עוצמה: עוצמה היא פשוט הממוצע של ערכי ה-
    let width = image.width
    let height = image.height
    let size = width * height
    let two_pi = 2 * 3.141592653589793

    let mut r = 0
    let mut g = 0
    let mut b = 0
    let mut hue = 0
//מערך דינמי עבור כל גוון
    let hsi_0 = alloc()
    let hsi_1 = alloc()
    let hsi_2 = alloc()

    for idx in range(size):
        let pixel_idx = idx * 4
        let r = image.pixels_bk[pixel_idx]
        let g = image.pixels_bk[pixel_idx + 1]
        let b = image.pixels_bk[pixel_idx + 2]

        let (r_norm, g_norm, b_norm) = normalize_rgb_value(r, g, b)
        
        let diff_rg = r_norm - g_norm
        let diff_rb = r_norm - b_norm
        let sum_gb = g_norm + b_norm

        let hue_num = 0.5 * (diff_rg + diff_rb)
        let hue_denom = sqrt(diff_rg * diff_rg + diff_rb * (g_norm - b_norm)) + 0.001
        hue = acos(hue_num / hue_denom)

        if b_norm > g_norm:
            hue = two_pi - hue

        let intensity = (r_norm + g_norm + b_norm) / 3
        let min_rgb = min(r_norm, g_norm, b_norm)
        let saturation = 1.0 - 3.0 / (r_norm + g_norm + b_norm) * min_rgb

        hsi_0[idx] = hue
        hsi_1[idx] = saturation
        hsi_2[idx] = intensity

    image.hsi = (hsi_0, hsi_1, hsi_2)
    return ()