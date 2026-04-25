-we run into multiple trouble while importing the sprite from internet
-problem like have black bg while using old command 

Ex: ffmpeg -i "C:\Users\Poundpx\Desktop\frames\webSpecial.webm" -vf "fps=24,scale=1000:1000" "C:\Users\Poundpx\Desktop\frames\Special\frame_%04d.png"
=> this code take webm file and convert to frame in folder special!
![[Pasted image 20260425012419.png]]
=> this out put  gave a black bg with single sprite frame by frame which is good but not ideal since we working with alots of sprite and we dont have the technical capability 


-------------------------------------------------------------------------
Solution:

For some reason switching from single sprite to sprite sheet option we were able to handle the error of black back ground and its transparent 
but draw back of doing these some frame got drop so we need keep all the frame while extract to 60 fps instead of 24 like above doing this it make the frame smoother 

Ex: ffmpeg -c:v libvpx -i "webRelax.webm" -vf "tile=13x13" -r 60 "Relax_spritesheet.png"
![[Pasted image 20260425012518.png]]=> as you can see all frame got capture 60fps and we can use this by slicing it inside godot for animation (click 2d animation and click add sprite using sprite sheet)
![[Pasted image 20260425012612.png|475]]
after that you need splice horizontal and vertical to according for equally 
![[Pasted image 20260425012725.png]] you can see the line not cut through character if you put horizontal and vertical correct 

->after that select all frame and import to new animation