%% This program write an input file for naca456, runs it, and then
%  converts to different input files for various CFD programs

%% Here are the definitions of the naca456 input variables

% NAMELIST /NACA/ a,camber,cl,chord,cmax,dencode,leindex,name,ntable, &
%   profile,toc,xmaxc,xmaxt,xorigin,yorigin,xtable

% The variables have the following meanings:
%     a         extent of constant loading (as fraction of chord)
%              	(only applies to 6-digit camber lines )	
%     camber  	Name of the camber line, enclosed in quotes.
%             	Acceptable values are '0', '2', '3', '3R', '6' and '6A'
%     cl		design lift coefficient of the camber line
%             	(Applies to three-digit, three-digit-reflex, 6-series and 
%             	6A-series camber lines)
%     chord		Model chord used for listing ordinates in dimensional units.
%     cmax		Maximum camber, as a fraction of chord.
%     dencode 	spacing of the x-array where the points are computed
%               =0 if specified by user
%               =1 for coarse output
%               =2 for fine output
%               =3 for very fine output
%     leindex	leading edge radius parameter
%              	(only applies to 4-digit-modified profiles)
%     name		Title desired on output. It must be enclosed in quotes.
%     ntable	Size of xtable (Only if dencode==0)
%     profile	Thickness family name, enclosed in quotes.
%              	Acceptable values are '4', '4M', '6', '6A'.
%     toc		Thickness-chord ratio of airfoil (fraction, not percent)
%     xmaxc		chordwise position of maximum camber, given as fraction of chord.
%             	(Only used for two digit camber lines)
%     xmaxt		Chordwise location of maximum thickness, as fraction of chord.
%             	( Only used for 4-digit modified airfoils)
%     xorigin	X-coordinate of the leading edge of the airfoil
%     yorigin	Y-coordinate of the leading edge of the airfoil            
%     xtable	table of points (ntable values) at which the airfoil ordinates
%               will be computed
%      

% user needs to specify these variables for naca456:
name    = 'NACA_4415_danny';
camber  = '2';              
profile = '4';              
xmaxc   = 0.4;              
cmax    = 0.04;             
toc     = 0.15;
xorigin = 0;
yorigin = 0;
% can specify customized cooridinates, or accept the spacing computed by naca456
denCode = 3;
if denCode == 0
    ntable  = 200;
%     x_c = cosspace(0, 1, ntable, 'start');
%     x_c = cosspace(0, 1, ntable, 'end');
    x_c = cosspace(0, 1, ntable, 'both');
end
              

% compute a customized table of coordinates for naca456; namely this is a high resolution version:
useCustomResolution = true;         % use the default option of "dencode" (if false) or can specify higher resoltution cosine or equal spacing
spacing             = 'cosine';     % can choose 'cosine' or 'equal' for spacing of the x-coordinates
nx                  = 103;          % number or coordinates in the x-directions (chordwise direction)

%% From here on, no more user intervention should be required, best luck!
%
%% run the naca456 program

% compute a customized table of coordinates for naca456; this is a higher resolution version:
if useCustomResolution
    
    switch spacing       
    case 'equal'
        x_cUp = linspace(0, 1, ntable/2 + 1)';
        
    case 'cosine'
        x_cUp = cosspace(0, 1, ntable/2 + 1, 'both');
    end
    x_cLo = flipud( x_cUp );
    
end
    

% write the input file for naca456, via the naca456 rules, the first argument begins with 
fid = fopen([name '.nml'],'w');
    fprintf(fid, '&NACA, \n');
    fprintf(fid, 'name    = ''%s'', \n',name);
    fprintf(fid, 'camber  = ''%s'', \n',camber);
    fprintf(fid, 'profile = ''%s'', \n',profile);
    fprintf(fid, 'xmaxc   = %g, \n',xmaxc);
    fprintf(fid, 'cmax    = %g, \n',cmax);
    fprintf(fid, 'toc     = %g, \n',toc);
    fprintf(fid, 'ntable  = %g, \n',ntable);
    fprintf(fid, 'denCode = %g/ \n',denCode);       % via the naca456 rules, the last argument ends with: /
fclose(fid);

% specify custom x-coordinates for the naca456 program
interp_type = asdf;
switch interp_type
    case 'asdf'
        xy_dat_airfoil456 = asdf();
    case 'asdf2'

        % spline the output from naca456
        xy_dat_airfoil456 = asdf;
end








% run naca456 from the command line
system(['naca456 ' name '.nml'])
system(['naca456 ' name '.nml ' x_456])

% read the output from naca456
read_naca456(OPTIONS.asdf);


%% write input files for other valuable programs:
% xfoil
write_airfoil_xfoil()


% mses
write_airfoil_mses()


% openfoam
write_airfoil_openfoam()


% starccm+
write_airfoil_starccm()


% harp_opt
write_airfoil_harpopt()


% co-blade
write_airfoil_coblade()



%% asfd














