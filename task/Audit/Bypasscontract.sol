///מסקנה
// פונקציה זו מטרתה לדעת האם החוזה שקיבלתי הוא חוזה חכם או לא
/// ואת זה ניתן היה לדעת עי שבדקנו את כמות הביטים בכתובת (פונקציה :extcodesize שהפלט הוא מס הביטים )
//אם גדול מאפס סימן שזה חוזה חכם ואם לאו סתם כגון:ארנק
//extcodesize דרך זו לא נכונה מאחר ויכול ליהות שקרים (assembly)
//דרך נכונה למצוא זאת היא עי השורה הבאה  return account.code.length > 0;