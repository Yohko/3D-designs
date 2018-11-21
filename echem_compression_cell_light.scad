// Licence: GNU General Public License version 2 (GPLv2)
$fn = 60; // how round should be curves
inch = 25.4; // for unit conversion 

// -------- Cell parameters -----------------
WE_square = 0; // 0 .. for round WE, 1 .. for square WE
h_CE = 1.71; // for round WE
//h_CE = 1.95; // for square CE

//height = 3;
height = 2.875; // two fit two cells into a 2x6x0.5 PEEK piece
width = 2;
d_screws = 0.17;
d_0p25_28 = 0.2;  // 1/4''-28, thread needs to be tapped later
d_0p125_NTP = 0.33;//0.41 // 1/8'' NPT, thread needs to be tapped later
h_WE = 0.922; // for WE

areaWE = 2; //cm^2, only used for square WE
dWE = sqrt(2)/2.54; // diameter working electrode
//echo(dWE);
dCE = 0.44; // diameter counter electrode

// small o-ring (015): https://www.mcmaster.com/9319K15
O_015_ID = 0.551;
O_015_OD = 0.7;//0.691;
O_015_W = 0.085;//0.07;
O_015_H = 0.052; // depth of groove
// big o-ring (019): https://www.mcmaster.com/9319K142
O_019_ID = 0.801;
O_019_OD = 0.941;
O_019_ODsq = 0.755957454;
O_019_W = 0.07;
// ------------------------------------------


// create pieces
translate([0,0,0.5*inch])rotate([-90,0,0]){
translate([2.5*inch,0.25*inch,3.5*inch])back(0.25);
translate([0*inch,0.25*inch,3.5*inch])front(0.25);
CE(0.5);
translate([2.5*inch,0,0])WE(0.5);
}


module back(d){
    // will be also used as a template for all other pieces
    difference(){
        cube(size = [width*inch,d*inch,height*inch], center = false);
        // screw holes
        rotate([-90,0,0])translate([0.23*inch,-0.33*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(width-0.23)*inch,-0.33*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([0.23*inch,-2.1*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(width-0.23)*inch,-2.1*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);    
    }
}


module front(d){
    difference(){
        back(d);
        if(WE_square == 0){
            rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,-1])cylinder(r=dCE/2*inch, h=d*inch+2);
        }else{
            rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,d/2*inch])roundCornersCube(dWE*inch,dWE*inch,d*inch+2,1);
        }
    }
}


module CE(d){
    difference(){
        back(d);
        // bottom hole 
        if(WE_square == 0){
        // round version
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,-1])cylinder(r=dCE/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,-1])cylinder(r=0.79/2*inch, h=0.079*inch+1); // quartz window groove
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,0.079*inch-1])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove
        }else{
        // square version
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,d/2*inch])roundCornersCube(dWE*inch,dWE*inch,d*inch+2,1);
        translate([(1)*inch,0,h_WE*inch])cube(size = [1.05*inch,0.079*2*inch,1.05*inch], center = true); // quartz window
    rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,0.079*inch])hollowroundCornersCube(O_019_ODsq*inch,O_019_ODsq*inch,O_015_H*2*inch,1,0.075*inch); // o-ring groove
        }
        // top hole
        rotate([-90,0,0])translate([(1)*inch,-h_CE*inch,-1])cylinder(r=dCE/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(1)*inch,-h_CE*inch,-1])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove top
        rotate([-90,0,0])translate([(1)*inch,-h_CE*inch,(d-O_015_H)*inch])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove bottom
        // gas exhaust
        rotate([0,0,0])translate([1*inch,d/2*inch,(h_CE+dCE/2)*inch-1])cylinder(r=0.16/2*inch, h=1.25*inch+2);
        rotate([0,0,0])translate([1*inch,d/2*inch,(height-0.35)*inch])cylinder(r=d_0p25_28/2*inch, h=0.35*inch+2); // 1/4''-28 thread
    }
}


module WE(d){
    difference(){
        back(d);
        // bottom hole
        if(WE_square == 0){
        // round version
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,-1])cylinder(r=dCE/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,-1])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove top
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,(d-O_015_H)*inch])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove bottom
        }else{
        // square version
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,d/2*inch])roundCornersCube(dWE*inch,dWE*inch,d*inch+2,1);
       rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,0])hollowroundCornersCube(O_019_ODsq*inch,O_019_ODsq*inch,O_015_H*2*inch,1,0.075*inch); // o-ring groove top
        rotate([-90,0,0])translate([(1)*inch,-h_WE*inch,d*inch])hollowroundCornersCube(O_019_ODsq*inch,O_019_ODsq*inch,O_015_H*2*inch,1,0.075*inch); // o-ring groove bottom
        }
        // top hole
        rotate([-90,0,0])translate([(1)*inch,-h_CE*inch,-1])cylinder(r=dCE/2*inch, h=0.32*inch+1);
        rotate([-90,0,0])translate([(1)*inch,-h_CE*inch,-1])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove
        // gas exhaust
        rotate([0,0,0])translate([1*inch,d/2*inch,(h_CE+dCE-0.24)*inch])cylinder(r=0.16/2*inch, h=1.25*inch+2);
        rotate([0,0,0])translate([1*inch,d/2*inch,(height-0.35)*inch])cylinder(r=d_0p25_28/2*inch, h=0.35*inch+2); // 1/4''-28 thread
        // gas inlet
        rotate([0,0,0])translate([1*inch,d/2*inch,-1])cylinder(r=0.33/2*inch, h=(h_CE-dCE/2+0.08)*inch+1); // also connects both chambers
        rotate([0,0,0])translate([1*inch,d/2*inch,-1])cylinder(r=d_0p125_NTP/2*inch, h=(0.35)*inch+1); // 1/8'' NPT
        // temp sensor side        
        rotate([0,90,0])translate([-(height-2.08)*inch,d/2*inch,1*inch])cylinder(r=0.083/2*inch, h=(1)*inch+1);
        rotate([0,90,0])translate([-(height-2.08)*inch,d/2*inch,(2-0.35)*inch])cylinder(r=d_0p25_28/2*inch, h=(0.35)*inch+1); // 1/4''-28
        // reference electrode
        translate([0.4*inch,d/2*inch,-2])rotate([0,25,0])cylinder(r=0.063/2*inch, h=(1)*inch+1);
        translate([0.4*inch,d/2*inch,-2])rotate([0,25,0])cylinder(r=d_0p25_28/2*inch, h=(0.35)*inch+1); // 1/4''-28
    }
}


module hollowCylinder(d, h, wallWidth){
	difference(){
		cylinder(d=d, h=h);
		translate([0, 0, -0.1])cylinder(d=d-(wallWidth*2), h=h+0.2);
	}
}


module hollowroundCornersCube(x,y,z,r,wallWidth){
	difference(){
		roundCornersCube(x,y,z,r);
        translate([0, 0, -0.1])roundCornersCube(x-(wallWidth*2),y-(wallWidth*2),z+0.2,r);
	}
}


module roundCornersCube(x,y,z,r){
    hull(){
        translate([x/2-r,y/2-r])cylinder(z,r=r,center=true);
        translate([-x/2+r,y/2-r])cylinder(z,r=r,center=true);
        translate([x/2-r,-y/2+r])cylinder(z,r=r,center=true);
        translate([-x/2+r,-y/2+r])cylinder(z,r=r,center=true);
    }
}
