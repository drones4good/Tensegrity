//TODO:
//motor stacks need to be thicker walled and with a bigger hole. Hole at bottom of stack needs to be bigger. More flexibility
//Need cross piece to keep motor slice rigid and support FC and lipo
//slit ends need to have chamfer opening to allow bands to go in easier. Optional - rounder hole, easier on band
//Need round ends on sticks for safety

// increase the visual detail
$fn = 100;

//carbonend();
//motorclip();
//tensioner();
//tensioner2();
motor_gripper();

//stick(220,2);

//now add motor stacks
//NOTE: for just the 4 sticks without motors that you also need,
//comment out this part. It's symmetric, so you can use two
//of these as a left and a right.
//translate([7.5,40,-1.1])
//    motor_stack();
//translate([7.5,-40,-1.1])
//    motor_stack();

module stick(height,radius)
{
    //slit width, length and position along stick (y-axis)
    slit_w=1.2; slit_l=10; slit_Y=102;
    //thin end cut width and length from end
    end_w=0.4; end_l=8;
    //NOTE: using radius+2 on z axis heights so that the cutout is higher than the stick radius i.e. makes a hole
    
    //long stick with a slit cut in each end
    difference() {
        union() {
    rotate([90,0,0])
        cylinder(h=height-radius*2,r=radius,center=true);    //was h=180 r=3
        //dimple on each end
        translate([0,height/2-radius,0])
            sphere(r=radius);
        translate([0,-(height/2-radius),0])
            sphere(r=radius);
        } //union
    translate([0,height/2-end_l,0]) //was 82
        cube([slit_w,slit_l,radius+2],center=true);
    translate([0,-(height/2-end_l),0])
        cube([slit_w,slit_l,radius+2],center=true);
    //extra end thin cuts for keepers
    translate([0,height/2,0])
        cube([end_w,end_l,radius+2],center=true);
    translate([0,-height/2,0])
        cube([end_w,end_l,radius+2],center=true);
    //put a bigger cut in the end to make it easier to get the bands on
    //2 width and end_l/2 length
    translate([0,height/2,0])
        cube([2,end_l/2,radius+2],center=true);
    translate([0,-height/2,0])
        cube([2,end_l/2,radius+2],center=true);
    }
}

module carbonend()
{
    //this is the end piece that slots onto a carbon rod of 4mm
    difference()
    {
        //outer - 3mm rod +0.5 clearance with 3mm internal hole
        rotate([90,0,0])
            cylinder(15,2.5,2.5,center=true); //10,2.5,2.5
        //inner - 3mm rod to make 3mm internal hole in outer
        rotate([90,0,0])
            color([1,0,0]) cylinder(17,1.5,1.5,center=true); //12,1.5,1.5
        //slot
        translate([0,4,0]) cube([5,8,0.8],center=true); //t0,4,0 c5,5,1
    }
    
}

module motorclip()
{
    //this is one of the four clips that attach the quadcopter frame via a motor onto the carbon stick of the tensegrity frame
    difference()
    {
        union()
        {
        //outer - 3mm rod +0.5??1.0 clearance with 3mm internal hole - was t0,0,1 but raised to thicken top
        translate([0,0,1.4]) rotate([90,0,0]) //was2,2
            cylinder(10,2.6,2.6,center=true);
        //joint
    translate([1.8,0,1]) cube([2.5,3,2],center=true);
        //motor ring outer
        translate([8,0,2]) cylinder(h=4,r=5.25,center=true);
        }
        //inner - 3mm rod to make 3mm internal hole in outer
        translate([0,0,1]) rotate([90,0,0]) //changed 12,1.5,1.5 to 1.6
            color([1,0,0]) cylinder(12,1.6,1.6,center=true);
        //now cut a slot - was -1.5 and 5,12,1
        translate([0,0,-1.0]) cube([5,12,2],center=true);
        //inner hole in motor holder
        color([1,0,0]) translate([8,0,2]) cylinder(h=6,r=4,center=true);
    //slit in motor ring
    color([0,1,0]) translate([8,4.5,2]) cube([2,2,6],center=true);
    }  
}
    
module motor_stack(has_arms)
{
    //has_arms true, draw arms to attach to a stick, false - just the stack
    //draws the motor holder with the slit cut in the side
    //and two 45 degree support arms
    difference(){
        union() {
            color([0,0,1]) cylinder(h=12,r=5.25);
            translate([0,0,-0.9])
                color([0,0,1]) cylinder(h=3,r=6);
            if (has_arms) {
            rotate([0,0,45]) translate([-8,-4,1]) cube([12,2,2],center=true);
            rotate([0,0,-45]) translate([-8,4,1]) cube([12,2,2],center=true);
            }
        }
        translate([0,0,1])
            color([0,1,0]) cylinder(h=20,r=4.25);
        translate([0,0,-1])
              color([1,0,0]) cylinder(h=3.5,r=2.0);
        translate([6,0,5])
            color([1,0,1]) cube([8.5,2,16], center=true);
    }
}

//this one is rubbish, use tensioner2
module tensioner()
{
    //this is a tensioner for the strings
    cylinder(h=25,r=2.0,center=true);
    //scale([1,1,0.4]) sphere(r=2.5);
    for ( z = [-10.0:2.0:10.0]) //start:inc:stop
        translate([0,0,z]) scale([1,1,0.4]) sphere(r=2.5);
    //top with cut out
    translate([0,0,14]) {
        difference() {
            cube([4,2,4],center=true); //flat
            //circle hole
            color([1,0,0]) rotate([90,0,0]) cylinder(h=3,r=1.0,center=true);
            //side cut
            color([0,1,0]) translate([1.5,0,-0.5]) cube([3,3,1],center=true);
        }
    }
    //bottom with cut out
    translate([0,0,-14]) {
        difference() {
            cube([4,2,4],center=true);
            color([1,0,0]) rotate([90,0,0]) cylinder(h=3,r=1.0,center=true);
            //side cut
            color([0,1,0]) translate([-1.5,0,0.5]) cube([3,3,1],center=true);
        }
    }
}

//This is the best one to use - todo: make the opening a bit bigger
module tensioner2()
{
    //VERSION 2!!!
    //this is a tensioner for the strings
    difference() {
        scale([1,0.5,1]) cylinder(h=25,r=2.0,center=true);
        for ( z = [-10.0:4.0:10.0]) //start:inc:stop
            translate([2,0,z]) rotate([90,0,0]) cylinder(h=3,r=1,center=true);
        for ( z = [-8:4.0:10.0]) //start:inc:stop
            translate([-2,0,z]) rotate([90,0,0]) cylinder(h=3,r=1,center=true);
    }
    //top with cut out
    translate([0,0,14]) {
        difference() {
            cube([4,2,4],center=true); //flat
            //circle hole
            color([1,0,0]) rotate([90,0,0]) cylinder(h=3,r=1.0,center=true);
            //side cut
            color([0,1,0]) translate([1.5,0,-0.5]) cube([3,3,1],center=true);
        }
    }
    //bottom with cut out
    translate([0,0,-14]) {
        difference() {
            cube([4,2,4],center=true);
            color([1,0,0]) rotate([90,0,0]) cylinder(h=3,r=1.0,center=true);
            //side cut
            color([0,1,0]) translate([-1.5,0,0.5]) cube([3,3,1],center=true);
        }
    }
}

//used to grip a motor stack onto a carbon rod for frameless tensegrity
module motor_gripper() {
    difference() {
        union() {
            motor_stack(false); //stack with no arms
            translate([0,0,-1.5]) cube([22,12,2],center=true);
        }
        //screw hole
        color([1,0,0]) translate([-8.5,-3.5,-1]) cylinder(h=5,r=1,center=true);
        //screw hole
        color([1,0,0]) translate([8.5,3.5,-1]) cylinder(h=5,r=1,center=true);
        //motor stack hole
        //color([0,1,0]) cylinder(h=10,r=2,center=true);
        //carbon rod indent
        color([0,0,0]) translate([0,0,-2.5]) rotate([0,90,0]) cylinder(h=25,r=1,center=true);
    }
    
    //now the base piece - note upside down so holes on other diagonal
    translate([0,20,0]) {
        difference() {
            translate([0,0,-1.5]) cube([22,12,2],center=true);
            //screw hole
            color([1,0,0]) translate([-8.5,3.5,-1]) cylinder(h=5,r=1,center=true);
            //screw hole
            color([1,0,0]) translate([8.5,-3.5,-1]) cylinder(h=5,r=1,center=true);
            //carbon rod indent
            color([0,0,0]) translate([0,0,-2.5]) rotate([0,90,0]) cylinder(h=25,r=1,center=true);
        }
    }
}