classdef pc
    % Authors: Philip Calado, Piers Barnes, Ilario Gelmetti, Ben Hillman, 2018 Imperial College London
    % PC (Parameters Class) defines all the required properties for your
    % device. PC.BUILDDEV builds a structure PO.DEV (where PO is a Parameters Object)
    % that defines the properties of the device at every spatial mesh point, including
    % interfaces. Whenever PROPERTIES are overwritten in a protocol, the device should
    % be rebuilt manually using PC.BUILDDEV. The spatial mesh is a linear piece-wise mesh
    % and is built by the MESHGEN_X function. Details of how to define the mesh
    % are given below in the SPATIAL MESH SUBSECTION.

    properties (Constant)
        %% Physical constants
        kB = 8.617330350e-5;     % Boltzmann constant [eV K^-1]
        epp0 = 552434;           % Epsilon_0 [e^2 eV^-1 cm^-1] - Checked (02-11-15)
        q = 1;                   % Charge of the species in units of e.
        e = 1.60217662e-19;         % Elementary charge in Coulombs.
    end

    properties
        % Temperature [K]
        T = 300;

        %% Spatial mesh
        % Device Dimensions [cm]
        % The spatial mesh is a linear piece-wise mesh and is built by the
        % MESHGEN_X function using 2 arrays DCELL and PCELL,
        % which define the thickness and number of points of each layer
        % respectively.
        dcell = 400e-7;         % Layer and subsection thickness array
        pcell = 400;            % Points array

        %% Layer description
        % Define the layer type for each of the layers in the device. The
        % options are:
        % LAYER = standard layer
        % ACTIVE = standard layer but the properties of this layer are
        % flagged such that they can easily be accessed
        % JUNCTION = a region with graded properties between two materials
        % (either LAYER or ACTIVE type)
        % with different properties
        layer_type = {'active'}
        % STACK is used for reading the optical properties library.
        % The names here do not influence the electrical properties of the
        % device. See INDEX OF REFRACTION LIBRARY for choices- names must be entered
        % exactly as given in the column headings with the '_n', '_k' omitted
        stack = {'MAPICl'}

        % Define spatial cordinate system- typically this will be kept at
        % 0 for most applications
        % m=0 cartesian
        % m=1 cylindrical polar coordinates
        % m=2 spherical polar coordinates
        m = 0;

        % xmesh_type specification - see MESHGEN_X. Only type '3' is
        % currently in use
        xmesh_type = 5;

        %% Time mesh
        % The time mesh is dynamically generated by ODE15s- the mesh
        % defined by MESHGEN_T only defines the values of the points that
        % are read out and so does not influence convergence. Defining an
        % unecessarily high number of points however can be expensive owing
        % to interpolation of the solution.
        tmesh_type = 2;             % Mesh type- for use with meshgen_t
        t0 = 1e-16;                 % Initial log mesh time value
        tmax = 1e-12;               % Max time value
        tpoints = 100;              % Number of time points

        %% GENERAL CONTROL PARAMETERS
        OC = 0;                 % Closed circuit = 0, Open Circuit = 1
        Vapp = 0;               % Applied bias
        BC = 3;                 % Boundary Conditions. Must be set to one for first solution
        figson = 1;             % Toggle figures on/off
        meshx_figon = 0;        % Toggles x-mesh figures on/off
        mesht_figon = 0;        % Toggles t-mesh figures on/off
        side = 1;               % illumination side 1 = left, 2 = right
        calcJ = 0;              % Calculates Currents- slows down solving calcJ = 1, calculates DD currents at every position
        mobset = 1;             % Switch on/off electron hole mobility- MUST BE SET TO ZERO FOR INITIAL SOLUTION
        mobseti = 1;
        SRHset = 1;
        radset = 1;
        JV = 0;                 % Toggle run JV scan on/off
        prob_distro_function = 'Boltz';        % 'Fermi' = Fermi-Dirac, % 'Boltz' = Boltzmann statistics
        Fermi_limit = 0.2;      % Max allowable limit for Fermi levels beyond the bands [eV]
        Fermi_Dn_points = 400;  % No. of points in the Fermi-Dirac look-up table
        intgradfun = 'linear'      % Interface gradient function 'linear' = linear, 'erf' = 'error function'

        %% Generation
        % OM = Optical Model
        % 0 = Uniform Generation
        % 1 = Beer Lambert
        OM = 1;
        Int = 0;                % Bias Light intensity (multiples of g0 or 1 sun for Beer-Lambert)
        int1 = 0;
        int2 = 0;
        g0 = [2.6409e+21];      % Uniform generation rate [cm-3s-1]
        light_source1 = 'AM15';
        light_source2 = 'laser';
        laser_lambda1 = 0;
        laser_lambda2 = 638;
        g1_fun_type = 'constant'
        g2_fun_type = 'constant'
        g1_fun_arg = 0;
        g2_fun_arg = 0;
        % default: Approximate Uniform generation rate @ 1 Sun for 510 nm active layer thickness

        %% Pulse settings
        pulsepow = 10;          % Pulse power [mW cm-2] OM2 (Beer-Lambert and Transfer Matrix only)

        %%%%%%%%%%% LAYER MATERIAL PROPERTIES %%%%%%%%%%%%%%%%%%%%
        % Numerical values should be given as a row vector with the number of
        % entries equal to the number of layers specified in STACK

        %% Energy levels [eV]
        EA = [0];           % Electron affinity
        IP = [-1];           % Ionisation potential

        %% Equilibrium Fermi energies [eV]
        % These define the doping density in each layer- see NA and ND calculations in methods
        E0 = [-0.5];

        %% SRH trap energies [eV]
        % These must exist within the energy gap of the appropriate layers
        % and define the variables PT and NT in the expression:
        % U = (np-ni^2)/(taun(p+pt) +taup(n+nt))
        Et =[-0.5];

        %% Electrode Fermi energies [eV]
        % Fermi energies of the metal electrode. These define the built-in voltage, Vbi
        % and the boundary carrier concentrations nleft, pleft, nright, and
        % pright
        Phi_left = -0.6;
        Phi_right = -0.4;

        %% Effective Density Of States (eDOS) [cm-3]
        Nc = [1e19];
        Nv = [1e19];
        % PEDOT eDOS: https://aip.scitation.org/doi/10.1063/1.4824104
        % MAPI eDOS: F. Brivio, K. T. Butler, A. Walsh and M. van Schilfgaarde, Phys. Rev. B, 2014, 89, 155204.
        % PCBM eDOS:

        %% Mobile ions
        % Mobile ion defect density [cm-3]
        N_ionic_species = 1;
        K_anion = 1;                    % Coefficients to easily accelerate ions
        K_cation = 1;                   % Coefficients to easily accelerate ions
        Nani = [1e19];                            % A. Walsh et al. Angewandte Chemie, 2015, 127, 1811.
        Ncat = [1e19];
        % Approximate density of iodide sites [cm-3]
        % Limits the density of iodide vancancies
        DOSani = [1.21e22];                 % P. Calado thesis
        DOScat = [1.21e22];
        %% Mobilities   [cm2V-1s-1]
        mue = [1];         % electron mobility
        muh = [1];         % hole mobility

        muani = [1e-10];          % ion mobility
        mucat = [1e-14];
        % PTPD h+ mobility: https://pubs.rsc.org/en/content/articlehtml/2014/ra/c4ra05564k
        % PEDOT mue = 0.01 cm2V-1s-1 https://aip.scitation.org/doi/10.1063/1.4824104
        % TiO2 mue = 0.09 cm2V-1s-1 Bak2008
        % Spiro muh = 0.02 cm2V-1s-1 Hawash2018

        %% Relative dielectric constants
        epp = [10];

        %% Recombination
        % Radiative recombination, U = k(np - ni^2)
        % [cm3 s-1] Radiative Recombination coefficient
        krad = [3.6e-12];

        %% SRH time constants for each layer [s]
        taun = [1e6];           % [s] SRH time constant for electrons
        taup = [1e6];           % [s] SRH time constant for holes

        %% Surface recombination and extraction coefficients [cm s-1]
        % Descriptions given in the comments considering that holes are
        % extracted at left boundary, electrons at right boundary
        sn_l = 1e7;     % electron surface recombination velocity left boundary
        sn_r = 1e7;     % electron extraction velocity right boundary
        sp_l = 1e7;     % hole extraction left boundary
        sp_r = 1e7;     % hole surface recombination velocity right boundary

        %% Series resistance
        Rs = 0;
        Rs_initial = 0;         % Switch to allow linear ramp of Rs on first application

        %% Defect recombination rate coefficient
        % Currently not used
        k_defect_p = 0;
        k_defect_n = 0;
        
        %% Ionic recombination and generation rates
        k_iongen = [0,0,0,0,0];
        k_ionrec = [0,0,0,0,0];
        
        %% Current voltage scan parameters
        % Soon to be obselete
        Vstart = 0;             % Initial scan point
        Vend = 1.2;             % Final scan point
        JVscan_rate = 1;        % JV scan rate (Vs-1)
        JVscan_pnts = 100;      % JV scan points

        %% Dynamically created variables
        genspace = [];
        x = [];
        xx = [];
        x_ihalf = [];
        dev = [];
        dev_ihalf = [];
        t = [];
        xpoints = [];
        Vapp_params = [];
        Vapp_func = @(str) [];
        gx1 = [];       % Light source 1
        gx2 = [];       % Light source 2

        %% Voltage function parameters
        V_fun_type = 'constant';
        V_fun_arg = 0;
        
        % Define the default relative tolerance for the pdepe solver
        % 1e-3 is the default, can be decreased if more precision is needed
        % Solver options
        MaxStepFactor = 1;      % Multiplier for easy access to maximum time step
        RelTol = 1e-3;
        AbsTol = 1e-6;
        
        %% Impedance parameters
        J_E_func = [];
        J_E_func_tilted = [];
        E2_func = [];
    end

    %%  Properties whose values depend on other properties (see 'get' methods).
    properties (Dependent)
        active_layer
        d
        parr
        d_active
        dcum
        dcum0           % includes first entry as zero
        dEAdx
        dIPdx
        dNcdx
        dNvdx
        Dn
        Eg
        Eif
        NA
        ND
        Vbi
        n0
        nleft
        nright
        ni
        nt_bulk         % Density of CB electrons when Fermi level at trap state energy
        nt_inter
        p0
        pcum
        pcum0           % Includes first entry as zero
        pleft
        pright
        pt_bulk         % Density of VB holes when Fermi level at trap state energy
        pt_inter
        wn
        wp
        wscr            % Space charge region width
        x0              % Initial spatial mesh value

    end

    methods
        function par = pc(varargin)
            % Parameters constructor function- runs numerous checks that
            % the input properties are consistent with the model
            if length(varargin) == 1
                % Use argument as filepath and overwrite properties using
                % PC.IMPORTPROPERTIES
                filepath = varargin;
                par = pc.importproperties(par, filepath);
            elseif length(varargin) > 1
                filepath = varargin{1, 1};
                warning('pc should have 0 or 1 input arguments- only the first argument will be used for the filepath')
            end

            % Warn if tmesh_type is not correct
            if ~ any([1 2 3 4] == par.tmesh_type)
                warning('PARAMS.tmesh_type should be an integer from 1 to 3 inclusive. MESHGEN_T cannot generate a mesh if this is not the case.')
            end

            % Warn if xmesh_type is not correct
            if ~ any(1:1:5 == par.xmesh_type)
                warning('PARAMS.xmesh_type should be an integer from 1 to 5 inclusive. MESHGEN_X cannot generate a mesh if this is not the case.')
            end

            % Warn if doping density exceeds eDOS
            for i = 1:length(par.ND)
                if par.ND(i) > par.Nc(i) || par.NA(i) > par.Nc(i)
                    msg = 'Doping density must be less than eDOS. For consistent values ensure electrode workfunctions are within the band gap and check expressions for doping density in Dependent variables.';
                    error(msg);
                end
            end

            % Warn if trap energies are outside of band gap energies
            for i = 1:length(par.Et)
                if par.Et(i) >= par.EA(i) || par.Et(i) <= par.IP(i)
                    msg = 'Trap energies must exist within layer band gap.';
                    error(msg);
                end
            end

            % Warn if DOSani is set to zero in any layers - leads to
            % infinite diffusion rate
            for i = 1:length(par.DOSani)
                if par.DOSani(i) <= 0
                    msg = 'ion DOS (DOSani) cannot have zero or negative entries- choose a low value rather than zero e.g. 1';
                    error(msg);
                end
            end

            % Warn if electrode workfunctions are outside of boundary layer
            % bandgap
            if par.Phi_left < par.IP(1) || par.Phi_left > par.EA(1)
                msg = 'Left-hand workfunction (Phi_left) out of range: value must exist within left-hand layer band gap';
                error(msg)
            end

            if par.Phi_right < par.IP(end) || par.Phi_right > par.EA(end)
                msg = 'Right-hand workfunction (Phi_right) out of range: value must exist within right-hand layer band gap';
                error(msg)
            end

            % Warn if property array do not have the correct number of
            % layers. The layer thickness array is used to define the
            % number of layers
            if length(par.parr) ~= length(par.d)
                msg = 'Points array (parr) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.EA) ~= length(par.d)
                msg = 'Electron Affinity array (EA) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.IP) ~= length(par.d)
                msg = 'Ionisation Potential array (IP) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.mue) ~= length(par.d)
                msg = 'Electron mobility array (mue) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.muh) ~= length(par.d)
                msg = 'Hole mobility array (mue) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.muani) ~= length(par.d)
                msg = 'Ion mobility array (muh) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.NA) ~= length(par.d)
                msg = 'Acceptor density array (NA) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.ND) ~= length(par.d)
                msg = 'Donor density array (ND) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.Nc) ~= length(par.d)
                msg = 'Effective density of states array (Nc) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.Nv) ~= length(par.d)
                msg = 'Effective density of states array (Nv) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.Nani) ~= length(par.d)
                msg = 'Background ion density (Nani) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.DOSani) ~= length(par.d)
                msg = 'Ion density of states array (DOSani) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.epp) ~= length(par.d)
                msg = 'Relative dielectric constant array (epp) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.krad) ~= length(par.d)
                msg = 'Radiative recombination coefficient array (krad) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.E0) ~= length(par.d)
                msg = 'Equilibrium Fermi level array (E0) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.g0) ~= length(par.d)
                msg = 'Uniform generation array (g0) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.taun) ~= length(par.d)
                msg = 'Bulk SRH electron time constants array (taun_bulk) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.taup) ~= length(par.d)
                msg = 'Bulk SRH hole time constants array (taup_bulk) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            elseif length(par.Et) ~= length(par.d)
                msg = 'Bulk SRH trap energy array (Et) does not have the correct number of elements. Property arrays must have the same number of elements as the thickness array (d), except SRH properties for interfaces which should have length(d)-1 elements.';
                error(msg);
            end

            %% Device and generation builder
            % Import variables and structure, xx, gx1, gx2, and dev must be
            % refreshed when to rebuild the device for example when
            % changing device thickness on the fly. These are not present
            % in the dependent variables as it is too costly to have them
            % continuously called.
            par = pc.refresh(par);
        end

        function par = set.xmesh_type(par, value)
            %   SET.xmesh_type(PARAMS, VALUE) checks if VALUE is an integer
            %   from 1 to 3, and if so, changes PARAMS.xmesh_type to VALUE.
            %   Otherwise, a warning is shown. Runs automatically whenever
            %   xmesh_type is changed.
            if any(1:1:5 == value)
                par.xmesh_type = value;
            else
                error('PARAMS.xmesh_type should be an integer from 1 to 3 inclusive. MESHGEN_X cannot generate a mesh if this is not the case.')
            end
        end

        function par = set.tmesh_type(par, value)
            %   SET.tmesh_type(PARAMS, VALUE) checks if VALUE is an integer
            %   from 1 to 2, and if so, changes PARAMS.tmesh_type to VALUE.
            %   Otherwise, a warning is shown. Runs automatically whenever
            %   tmesh_type is changed.
            if any(1:1:4 == value)
                par.tmesh_type = value;
            else
                error('PARAMS.tmesh_type should be an integer from 1 to 4 inclusive. MESHGEN_T cannot generate a mesh if this is not the case.')
            end
        end

        function par = set.ND(par, value)
            for i = 1:length(par.ND)
                if value(i) >= par.Nc(i)
                    error('Doping density must be less than eDOS. For consistent values ensure electrode workfunctions are within the band gap.')
                end
            end
        end

        function par = set.NA(par, value)
            for i = 1:length(par.ND)
                if value(i) >= par.Nv(i)
                    error('Doping density must be less than eDOS. For consistent values ensure electrode workfunctions are within the band gap.')
                end
            end
        end

        %% Get active layer indexes from layer_type
        function value = get.active_layer(par)
            value = find(strncmp('active', par.layer_type,6));
            if length(value) == 0
                % If no flag is give assume active layer is middle
                value = round(length(par.layer_type)/2);
            end
        end

        %% Active layer thickness
        function value = get.d_active(par)
            value = sum(par.dcell(par.active_layer(1):par.active_layer(end)));
        end
        %% Layer thicknesses [cm]
        function value = get.d(par)
            % For backwards comptibility. pcell and parr arre the now the
            % same thing
            value = par.dcell;
        end

        %% Layer points
        function value = get.parr(par)
            % For backwards comptibility. pcell and parr arre the now the
            % same thing
            value = par.pcell;
        end

        %% Band gap energies    [eV]
        function value = get.Eg(par)
            value = par.EA - par.IP;
        end

        %% Built-in voltage Vbi based on difference in boundary workfunctions
        function value = get.Vbi(par)
            value = par.Phi_right - par.Phi_left;
        end

        %% Intrinsic Fermi Energies
        % Currently uses Boltzmann stats as approximation should always be
        function value = get.Eif(par)
            value = 0.5.*(par.EA+par.IP)+par.kB*par.T*log(par.Nc./par.Nv);
        end

        %% Donor densities
        function value = get.ND(par)
            value = zeros(1, length(par.stack));
            value = distro_fun.nfun(par.Nc, par.EA, par.E0, par.T, par.prob_distro_function);
        end

        %% Acceptor densities
        function value = get.NA(par)
            value = zeros(1, length(par.stack));
            value = distro_fun.pfun(par.Nv, par.IP, par.E0, par.T, par.prob_distro_function);
        end

        %% Intrinsic carrier densities (Boltzmann)
        function value = get.ni(par)
            value = par.Nc.*exp(-par.Eg./(2*par.kB*par.T));
        end

        %% Equilibrium electron densities
        function value = get.n0(par)
            value = distro_fun.nfun(par.Nc, par.EA, par.E0, par.T, par.prob_distro_function);
        end

        %% Equilibrium hole densities
        function value = get.p0(par)
            value = distro_fun.pfun(par.Nv, par.IP, par.E0, par.T, par.prob_distro_function);

        end

        %% Boundary electron and hole densities
        % Uses metal Fermi energies to calculate boundary densities
        % Electrons left boundary
        function value = get.nleft(par)
            value = distro_fun.nfun(par.Nc(1), par.EA(1), par.Phi_left, par.T, par.prob_distro_function);
        end

        % Electrons right boundary
        function value = get.nright(par)
            value = distro_fun.nfun(par.Nc(end), par.EA(end), par.Phi_right, par.T, par.prob_distro_function);
        end

        % Holes left boundary
        function value = get.pleft(par)
            value = distro_fun.pfun(par.Nv(1), par.IP(1), par.Phi_left, par.T, par.prob_distro_function);
        end

        % holes right boundary
        function value = get.pright(par)
            value = distro_fun.pfun(par.Nv(end), par.IP(end), par.Phi_right, par.T, par.prob_distro_function);
        end

        function value = get.dcum(par)
            value = cumsum(par.dcell);
        end

        function value = get.pcum(par)
            value = cumsum(par.pcell);
        end

        function value = get.pcum0(par)
            value = [1, cumsum(par.pcell)];
        end

        function value = get.dcum0(par)
            value = [0, cumsum(par.dcell)];
        end
    end

    methods (Static)

        function xx = xmeshini(par) % For backwards compatibility
            xx = meshgen_x(par);
        end

        function par = refresh(par)
            par.xx = meshgen_x(par);
            par.x_ihalf = getvarihalf(par.xx);
            par.dev = pc.builddev(par, 'iwhole');
            par.dev_ihalf = pc.builddev(par, 'ihalf');
            % Get generation profiles
            par.gx1 = pc.generation(par, par.light_source1, par.laser_lambda1);
            par.gx2 = pc.generation(par, par.light_source2, par.laser_lambda2);
        end
        
        function devprop = buildproperty(property, xmesh, par, interface_switch, gradient_property)
            % Builds the device property - i.e. defines the properties at
            % every x position in the device
            % property          - the variable name of the propery e.g. par.EA
            % xmesh             - as name suggests
            % par               - parameters object
            % interface_switch  -
            % 'zeroed' = set property value to zero for interfaces
            % 'constant' = constant property values in interfaces
            % 'lin_graded' = graded property values in interfaces
            % 'log_graded' = graded property values in interfaces
            % gradient_properties - 1 if the property is a gradient e.g.
            % dEAdx, 0 otherwise
            
            devprop = zeros(1, length(xmesh));
            
            for i=1:length(par.dcum)
                for j = 1:length(xmesh)
                    if any(strcmp(par.layer_type{1,i}, {'layer', 'active'})) == 1
                        if xmesh(j) >= par.dcum0(i)
                            if gradient_property == 1
                                devprop(j) = 0;
                            else
                                devprop(j) = property(i);
                            end
                        end
                    elseif any(strcmp(par.layer_type{1,i}, {'junction'})) == 1
                        % Interfaces
                        if xmesh(j) >= par.dcum0(i)
                            xprime = xmesh(j)-par.dcum0(i);
                            if xmesh(j) >= par.dcum0(i)
                                deff = par.d(i);
                                switch interface_switch
                                    case 'zeroed'
                                        devprop(j) = 0;
                                    case 'constant'
                                        devprop(j) = property(i);
                                    case 'lin_graded'
                                        gradient = (property(i+1)-property(i-1))/deff;
                                        if gradient_property == 1
                                            devprop(j) = gradient;
                                        else
                                            devprop(j) = property(i-1) + xprime*gradient;
                                        end
                                    case 'log_graded'
                                        log_gradient = (log(property(i+1))-log(property(i-1)))/deff;
                                        if gradient_property == 1
                                            devprop(j) = property(i-1)*log_gradient*exp(log_gradient*xprime);
                                        else
                                            devprop(j) = property(i-1)*exp(log_gradient*xprime);
                                        end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        
        function dev = builddev(par, meshoption)
            switch meshoption
                case 'iwhole'
                    xmesh = par.xx;
                case 'ihalf'
                    xmesh = getvarihalf(par.xx);
            end
            % BUILDDEV builds the properties for the device as
            % arrays such that each property can be called for
            % each point including grading at interfaces.
            
            % Linaerly graded properties
            dev.EA = pc.buildproperty(par.EA, xmesh, par, 'lin_graded', 0);
            dev.IP = pc.buildproperty(par.IP, xmesh, par, 'lin_graded', 0);
            dev.mue = pc.buildproperty(par.mue, xmesh, par, 'lin_graded', 0);
            dev.muh = pc.buildproperty(par.muh, xmesh, par, 'lin_graded', 0);
            dev.mucat = pc.buildproperty(par.mucat, xmesh, par, 'lin_graded', 0);
            dev.muani = pc.buildproperty(par.muani, xmesh, par, 'lin_graded', 0);
            dev.epp = pc.buildproperty(par.epp, xmesh, par, 'lin_graded', 0);
            dev.krad = pc.buildproperty(par.krad, xmesh, par, 'lin_graded', 0);
            dev.E0 = pc.buildproperty(par.E0, xmesh, par, 'lin_graded', 0);
            dev.Et = pc.buildproperty(par.Et, xmesh, par, 'lin_graded', 0);
            dev.taun = pc.buildproperty(par.taun, xmesh, par, 'constant', 0);
            dev.taup = pc.buildproperty(par.taup, xmesh, par, 'constant', 0);
            dev.k_iongen = pc.buildproperty(par.k_iongen, xmesh, par, 'lin_graded', 0);
            dev.k_ionrec = pc.buildproperty(par.k_ionrec, xmesh, par, 'lin_graded', 0);
            
            % Logarithmically graded properties
            dev.NA = pc.buildproperty(par.NA, xmesh, par, 'log_graded', 0);
            dev.ND = pc.buildproperty(par.ND, xmesh, par, 'log_graded', 0);
            dev.Nc = pc.buildproperty(par.Nc, xmesh, par, 'log_graded', 0);
            dev.Nv = pc.buildproperty(par.Nv, xmesh, par, 'log_graded', 0);
            dev.Nani = pc.buildproperty(par.Nani, xmesh, par, 'log_graded', 0);
            dev.Ncat = pc.buildproperty(par.Ncat, xmesh, par, 'log_graded', 0);
            dev.ni = pc.buildproperty(par.ni, xmesh, par, 'log_graded', 0);
            dev.n0 = pc.buildproperty(par.n0, xmesh, par, 'log_graded', 0);
            dev.p0 = pc.buildproperty(par.p0, xmesh, par, 'log_graded', 0);
            dev.DOSani = pc.buildproperty(par.DOSani, xmesh, par, 'log_graded', 0);
            dev.DOScat = pc.buildproperty(par.DOScat, xmesh, par, 'log_graded', 0);
            
            % Properties that are zeroed in the interfaces
            dev.g0 = pc.buildproperty(par.g0, xmesh, par, 'zeroed', 0);
        
            % Gradient properties
            dev.gradEA = pc.buildproperty(par.EA, xmesh, par, 'lin_graded', 1);
            dev.gradIP = pc.buildproperty(par.IP, xmesh, par, 'lin_graded', 1);
            dev.gradNc = pc.buildproperty(par.Nc, xmesh, par, 'log_graded', 1);
            dev.gradNv = pc.buildproperty(par.Nv, xmesh, par, 'log_graded', 1);
            
            dev.nt = distro_fun.nfun(dev.Nc, dev.EA, dev.Et, par.T, par.prob_distro_function);
            dev.pt = distro_fun.pfun(dev.Nv, dev.IP, dev.Et, par.T, par.prob_distro_function);
        end

        function gx = generation(par, source_type, laserlambda)
            % This function calls the correct funciton to calculate generation profiles as a function of position
            % SOURCE_TYPE = either 'AM15' or 'laser'
            % LASERLAMBDA = Laser wavelength - ignored if SOURCE_TYPE = AM15

            xsolver = getvarihalf(par.xx);
            switch par.OM
                case 0
                    gx = getvarihalf(par.dev.g0);    % This currently results in the generation profile being stored twice and could be optimised
                case 1
                    % beerlambert(par, x, source_type, laserlambda, figson)
                    gx = beerlambert(par, par.xx, source_type, laserlambda, 0);
                    % interpolate for i+0.5 mesh
                    gx = interp1(par.xx, gx, xsolver);
            end

        end

        function par = importproperties(par, filepath)
            % A function to overwrite the properties in par with those imported from a
            % text file located in filepath
            T = readtable(filepath{1,1});

            par.layer_type = T{:,'layer_type'}';
            par.stack = T{:,'stack'}';
            par.dcell = T{:, 'thickness'}';
            par.pcell = T{:, 'points'}';
            par.EA = T{:, 'EA'}';
            par.IP = T{:, 'IP'}';
            par.E0 = T{:, 'E0'}';

            par.Nc = T{:, 'Nc'}';
            par.Nv = T{:, 'Nv'}';
            try
                par.Nani = T{:, 'Nion'}';   % Backward compatibility
            end
            try
                par.Nani = T{:, 'Nani'}';
            end
            par.Ncat = T{:, 'Ncat'}';
            try
                par.DOSani = T{:, 'DOSion'}';   % backwards compatibility
            end
            try
                par.DOSani = T{:, 'DOSani'}';
            end
            par.DOScat = T{:, 'DOScat'}';
            par.mue = T{:, 'mue'}';
            par.muh = T{:, 'muh'}';
            try
                par.muani = T{:, 'muion'}';
            end

            try
                par.muani = T{:, 'muani'}';
            end
            par.mucat = T{:, 'mucat'}';
            par.epp = T{:, 'epp'}';

            try
                par.g0 = T{:, 'G0'}';   % For backwards compatibility
            end

            try
                par.g0 = T{:, 'g0'}';
            end

            par.krad = T{:, 'krad'}';
            par.taun = T{:, 'taun_SRH'}';
            par.taup = T{:, 'taup_SRH'}';
            par.sn_l = T{1, 'sn_l'}';
            par.sp_l = T{1, 'sp_l'}';
            par.sn_r = T{1, 'sn_r'}';
            par.sp_r = T{1, 'sp_r'}';

            try
                par.Phi_left = T{1, 'PhiA'};
            end

            try
                par.Phi_left = T{1, 'Phi_left'};    % For backwards compatibility
            end

            try
                par.Phi_right = T{1, 'PhiC'};       % For backwards compatibility
            end

            try
                par.Phi_right = T{1, 'Phi_right'};
            end
            
            try
                par.Rs = T{1, 'Rs'};
            end
            
            try
                par.Et = T{:,'Et'}';
            end

            try
                par.Et = T{:,'Et_bulk'}';   % For backwards compatibility
            end

            try
                par.OM = T{1, 'OM'};
            catch
                warning('No optical model (OM) specified in .csv Using default in PC')
            end

            try
                par.xmesh_type = T{1, 'xmesh_type'};
            catch
                warning('No spatial mesh type (xmesh_type) defined in .csv . Using default in PC')
            end

            try
                par.side = T{1, 'side'};
            catch
                warning('Illumination side (side) undefined in .csv . Using default in PC')
            end

            try
                par.N_ionic_species = T{1, 'N_ionic_species'};
            catch
                warning('No of ionic species (N_ionic_species) undefined in .csv. Using default in PC')
            end

        end
    end

end
