function [] = UK_subplot(data,collim,figname)
% [] = UK_subplot(data,collim,figname)
%
% Do a plot of the UK region in transmercator projection
%
% Inputs:
%   data - the dataset to be plotted
%   collim - the colour range limits (e.g. [35 54])
%   figname - title (string) for the subplot (e.g. 'GCM 1980-2010 max. HD')


%% Find which machine is being used
curdir = pwd;
if strcmp(curdir(1:14),'/Users/ak0920/')
    ncdatadir1 = '/Users/ak0920/Data/IMPRES/';
    ncdatadir2 = '/huss/run01/';
else
    if srtcmp(curdir(1:14),'/home/bridge/a')
        ncdatadir1 = '/export/anthropocene/array-01/ak0920/ukcp18_data/';
        ncdatadir2 = '/huss/day/run01/';
    end
end

%% Load lat-long and coast data for plotting
generate_UK_latlon

if length(data(1,:,1)) == 23
    
    % GCM lat-long
    % lon = ncread([ncdatadir1,'60km',ncdatadir2,'huss_rcp85_land-gcm_uk_60km_01_day_19791201-19891130.nc'],'longitude');
    % lat = ncread([ncdatadir1,'60km',ncdatadir2,'huss_rcp85_land-gcm_uk_60km_01_day_19791201-19891130.nc'],'latitude');
    lon = long_UK_GCM;
    lat = lat_UK_GCM;
    
    
else
    if length(data(1,:,1)) == 112
        
        % RCM lat-long
        %         x_rcm = ncread([ncdatadir1,'12km',ncdatadir2,'huss_rcp85_land-rcm_uk_12km_01_day_19801201-19901130.nc'],'projection_x_coordinate');
        %         y_rcm = ncread([ncdatadir1,'12km',ncdatadir2,'huss_rcp85_land-rcm_uk_12km_01_day_19801201-19901130.nc'],'projection_y_coordinate');
        %         [xs,ys]=meshgrid(x_rcm,y_rcm);
        %         [lat,lon] = os2ll(xs,ys);
        %         lat = flipud(rot90(lat));
        %         lon = flipud(rot90(lon));
        lon = long_UK_RCM;
        lat = lat_UK_RCM;
        
    else
        if length(data(1,:,1)) == 121
            % ERA5 lat-long
            %             lon = ncread([ncdatadir1,'OtherData/WFDEI/huss_wfdei_1981_1990.nc'],'lon');
            %             lat = ncread([ncdatadir1,'OtherData/WFDEI/huss_wfdei_1981_1990.nc'],'lat');
            %             [lon,lat]=meshgrid(lon,lat);
            %             lat = flipud(rot90(lat))+0.25;
            %             lon = flipud(rot90(lon));
            lat = lat_UK_ERA5;
            lon = long_UK_ERA5;
            
            %             sublong = 330:372;
            %             sublat = 56:86;
            %
            %             lon = lon(sublong,sublat);
            %             lat = lat(sublong,sublat);
        else
            if length(data(1,:,1)) == 606
                lat = lat_UK_CPM;
                lon = long_UK_CPM;
            else
                if length(data(1,:,1)) == 1450
                    lat = lat_UK_HadUK1;
                    lon = long_UK_HadUK1;
                else
                    if length(data(1,:,1)) == 110
                        lat = lat_UK_HadUK12;
                        lon = long_UK_HadUK12;
                        
                    else
                        if length(data(1,:,1)) == 42
                            lat = lat_UK_ERA5(49:88,42:83);
                            lon = long_UK_ERA5(49:88,42:83);
                        end
                        
                        
                        
                    end
                    
                end
            end
        end
    end
end
% Coastline
S = shaperead('landareas','UseGeoCoords',true);

% lat-long limits for plotting
latlim = [48 61];
lonlim = [-15 7];


%% Plotting
% Set up axes
axesm('MapProjection','Tranmerc', 'MapLatLim', latlim,...
    'MapLonLim', lonlim, 'MLineLocation', 5,...
    'PlineLocation', 5, 'MLabelParallel', 'south')

% Plot the data
pcolorm(lat,lon,data)

% Adjust the plot
framem('FEdgeColor', 'black', 'FLineWidth', 1)
gridm('Gcolor',[0.3 0.3 0.3])
tightmap
box off
axis off

% Specify colour limit if necessary
if exist('collim','var')
    caxis(collim)
end

% Add coastline
hold on
geoshow([S.Lat], [S.Lon],'Color','black');

% Add title if ncessary
if exist('figname','var')
    title(figname)
end