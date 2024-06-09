//core  is a library that provides essential functionalities without needing the standard library.
//זה ספיריה שמספקת צרכים חיוניים 
//panic_with_felt256 שגיאות של מספרים 
use core ::panic_with_felt252;
use dict::Felt252DictTrait;
use array::ArrayTrait;
use debug::PrintTrait;
fn rotate(imageData: @Array<u256>,degress:u256)->Array<u256> {
    //הפונקציה מקבלת 2 פרמטרים מערך שמבטא תמונה וכן מספר 
    //הפונקציה מחזירה מערך מטיפוב int 
    let width=3;
    let height=width;
    //הגדרת מיליון לצורך עזר בסיסוב התמונה 
    //mut מאפשר שינוי לאחר ההצהרה של המשתנה 
    let mut dict_rotate=felt252_dict_new::<u32>();
    //המפתח יהיה עד 256 ביטים 
    //הערך עד 323 ביטים
    if degress == 90{
        let mut i:u32 =0 ;
        let mut j:u32 =0;
        loop{
            if i == width{
                break();
            }
            j=0;
            loop{
                if j == height{
                    break();
                }
                //.into() ממירה את התוצאה לטיפוס הרצוי כאן 252
                //(j*width) שורות 
                //(width-i-1) עמודות 
                let newIndex:felt252 =((j*width)+(width-i-1)).into();
                //u32 ממירה את התוצאה 
                let value: u32 = (*imageData.at(i * height + j)).try_into().unwrap();

                dict_rotate.insert(newIndex,value);
                j = j + 1;
            };
            i = i +1;
        };
        //לכיוון ההפוך 
    }else
     if degress == 270 {
        let mut i: u32 = 0;
        let mut j: u32 = 0;
        loop {
            if i == width { 
                break ();
            }
            j = 0;
            loop {
                if j == height {
                    break();
                }
                let newIndex: felt252 = (((height - j - 1) * width) + i).into();
                let value: u32 = (*imageData.at(i * height + j)).try_into().unwrap();
                dict_rotate.insert(newIndex, value);
                j = j+ 1;
            };
            i = i + 1;
        };  
    }  
    else{
        let x =404;
        panic_with_felt252(x);
    }
    let mut rotatedImage:Array<u256> = ArrayTrait::new();
    let mut k :u32 = 0;
    loop{
        if k == imageData.len()
        {
            break();
        }
        let newIndex: felt252 = (k).into();
        let value:u256 = dict_rotate[newIndex].into();
        //push new array after rotate
        rotatedImage.append(value);
        k= k +1;

    };
    rotatedImage
}

fn main(){
    let mut arr = ArrayTrait::new();
    arr.append(3);
    arr.append(10);
    arr.append(3);
    arr.append(10);
    arr.append(2);
    arr.append(3);
    arr.append(10);
    arr.append(3);
    arr.append(10);
    rotate(@arr,90);
    'success'.print();
}