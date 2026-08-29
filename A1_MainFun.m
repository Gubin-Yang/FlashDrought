clc;clear;close all
load Mask
addpath MyFun
load Coordinate.mat
% SMpct5d_GDFCX=load("HistReanalysis/Observed_GDFC.mat","SMrootpct5d","SMsurfpct5d","maskPRE","date5d");
% SMpct5d_GLDAS=load("HistReanalysis/Observed_GLDAS.mat","SMrootpct5d","SMsurfpct5d","maskPRE");
% SMpct5d_ERA5X=load("HistReanalysis/Observed_ERA5.mat","SMrootpct5d","maskPRE",'SMsurfpct5d','SMsurf1pct5d','SMsurf2pct5d');
% SMpct5d_MeanX=load("HistReanalysis/Observed_Median.mat","SMrootpct5d","SMsurfpct5d");

%% 1. Standardized indices to flash-drought events
SMrootModelName={'GDFC','GLDS','ERA5','Mean','AWI-ESM-1-1-LR','AWI-ESM-1-REcoM','CNRM-CM6-1','CNRM-ESM2-1','HadGEM3-GC31-LL','ICON-ESM-LR','IPSL-CM6A-LR','MPI-ESM-1-2-HAM','MPI-ESM1-2-HR','MPI-ESM1-2-LR','UKESM'};
SMsurfModelName={'GDFC','GLDS','ERA5','Mean','ACCESS-CM2','ACCESS-ESM1-5','AWI-ESM-1-1-LR','AWI-ESM-1-REcoM','BCC-CSM2-MR','BCC-ESM1','CanESM5','CNRM-CM6-1','CNRM-ESM2-1','HadGEM3-GC31-LL','ICON-ESM-LR','INM-CM4-8','INM-CM5-0','IPSL-CM6A-LR','MIROC6','MPI-ESM-1-2-HAM','MPI-ESM1-2-HR','MPI-ESM1-2-LR','MRI-ESM2-0','NorESM2-MM','UKESM1-0-LL'};

% 1. Root zone
% for i=1:length(SMrootModelName)
%     disp(SMrootModelName{i})
%     load(['StandardizedIndexSSI/' SMrootModelName{i}])
%     fdName=fieldnames(NormGCM);
%     for j=1:length(fdName)
%         [FD.(fdName{j}),FDsNumMat.(fdName{j}),FDsDMat.(fdName{j}),FDhc.(fdName{j}),downpmat.(fdName{j})]=FDenvent(NormGCM.(fdName{j}));
%     end
%     % [FD,FDsNumMat,FDsDMat,FDhc,downpmat]=FDenvent_Opt(NormGCM.historical);% Updated implementation
%     save(['FlashDroughtEvent/' SMrootModelName{i}],"FD",'FDsNumMat','FDsDMat','FDhc','downpmat')
%     clear FD FDsNumMat FDsDMat FDhc downpmat NormGCM
% end

% % 1. Surface layer
% for i=1:length(SMsurfModelName)
%     disp(SMsurfModelName{i})
%     load(['StandardizedIndexSSI/' SMsurfModelName{i} '表层'])
%     fdName=fieldnames(NormGCM);
%     for j=1:length(fdName)
%         [FD.(fdName{j}),FDsNumMat.(fdName{j}),FDsDMat.(fdName{j}),FDhc.(fdName{j}),downpmat.(fdName{j})]=FDenvent(NormGCM.(fdName{j}));
%     end
%     % [FD,FDsNumMat,FDsDMat,FDhc,downpmat]=FDenvent_Opt(NormGCM.historical);% Updated implementation
%     save(['FlashDroughtEvent/' SMsurfModelName{i} '表层'],"FD",'FDsNumMat','FDsDMat','FDhc','downpmat')
%     clear FD FDsNumMat FDsDMat FDhc downpmat NormGCM
% end
% % %
% seeFD(FD.(fdName{j}),'BackgroundData',NormGCM.(fdName{j}))
% GCMs
% for i=1:4
%     disp(SSP{i})
%     [FDsCell_gcm{i},FDsNum_gcm{i},FDsD_gcm{i},FDhc_gcm{i},down_gcm{i}]=cellfun(@FDenventEns,SSI_gcm{i},'UniformOutput',false);
% end
% save FlashDroughtEvent/GCMFlashDroughtEvent FDsCell_gcm FDsNum_gcm FDsD_gcm FDhc_gcm down_gcm
%% 2. Flash-drought frequency across soil-moisture datasets, depths, and their differences
intersectModelName=intersect(SMsurfModelName,SMrootModelName);% Models with both surface and root-zone soil moisture
% for i=1:length(intersectModelName)
%     FDroot=load(['FlashDroughtEvent/' intersectModelName{i}]);
%     FDsurf=load(['FlashDroughtEvent/' intersectModelName{i} '表层']);
%     Fra_SMroot=FDroot.FDsNumMat.historical/65;
%     Fra_SMsurf=FDsurf.FDsNumMat.historical/65;
%     Dur_SMroot=FDroot.FDsDMat.historical;
%     Dur_SMsurf=FDsurf.FDsDMat.historical;
%     Risk_SMroot(:,:,i)=Fra_SMroot.*Dur_SMroot;
%     Risk_SMsurf(:,:,i)=Fra_SMsurf.*Dur_SMsurf;
%     % if i==length(intersectModelName) % Ensemble-mean model
%     %     globalMap(Risk_SMsurf(:,:,i), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12,'r'),'clim',[0 3],'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString',[intersectModelName{i} '-SMsurf'],'ColorBarLabel','[counts·pentad·yr^{-1}]')
%     %     globalMap(Risk_SMroot(:,:,i), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12,'r'),'clim',[0 3],'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString',[intersectModelName{i} '-SMroot'],'ColorBarLabel','[counts·pentad·yr^{-1}]')
%     % end
%     % globalMap(FDroot.FDsNumMat, latForm, lonForm,'RGB',RGBredblu,'Projection','eckert3','shadow',maskpre,'TitleString',titx{i},'ColorBarLabel','Mean duration [pentads·yr^{-1}]')
% end
% % Ensemble mean
% save RiskDeep Risk_SMsurf Risk_SMroot intersectModelName
load RiskDeep
globalMap(mean(Risk_SMsurf,3), latForm, lonForm,'Region','gj','clercmap',0,'RGB',MatCM(94,12,'r'),'clim',[0 3],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','Surf Soil Moisture','ColorBarLabel','[counts·pentad·yr^{-1}]')
GeoMapCount(mean(Risk_SMsurf,3), latForm, lonForm,'region','gj','Math','mean','RGB',MatCM(19,12),'Projection','pcarree','shadow',maskpre,'ShowIPCCname',0,'remeth',"nearest",'climx',[0 2],'defaultsubplot',0,'TitleString','','ColorBarLabel','[Nats·yr^{-1}]')
[~,DZ7VALUE,DZ7]=GeoMap7DZ(mean(Risk_SMsurf,3), latForm, lonForm,'region','7dz','Math','mean','RGB',MatCM(19,12),'Projection','pcarree','shadow',maskpre,'ShowIPCCname',1,'remeth',"nearest",'climx',[0 2],'defaultsubplot',0,'TitleString','','ColorBarLabel','[Nats·yr^{-1}]');

globalMap(mean(Risk_SMroot,3), latForm, lonForm,'Region','gj','clercmap',0,'RGB',MatCM(94,12,'r'),'clim',[0 3],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','Root‑Zone Soil Moisture','ColorBarLabel','[counts·pentad·yr^{-1}]')
globalMapIPCC1(mean(Risk_SMroot,3), latForm, lonForm,'region','gj','Math','mean','RGB',MatCM(19,12),'Projection','eckert3','shadow',maskpre,'ShowIPCCname',1,'remeth',"nearest",'climx',[0 3],'defaultsubplot',0,'TitleString','','ColorBarLabel','[Nats·yr^{-1}]')

% GeoMapCount(mean(Risk_SMroot,3), latForm, lonForm,'region','gj','Math','mean','RGB',MatCM(19,12),'Projection','eckert3','shadow',maskpre,'ShowIPCCname',0,'remeth',"nearest",'climx',[0 3],'defaultsubplot',0,'TitleString','','ColorBarLabel','[Nats·yr^{-1}]')
% PlotLonNew(Risk_SMsurf,1,[0 3],1.5,true)
PlotLonNew(Risk_SMroot,1,[0 3],1.5,false)
plotBarAnom(squeeze(nanmedian(Risk_SMroot,[1 2])),squeeze(nanmedian(Risk_SMsurf,[1 2])),intersectModelName)
date=get_year_month_day(1950,2014,"noleap");
date5d=date(5:5:end,:);
% %% Fig. 1c. Mean annual flash-drought onset duration in the root zone (main text)
% for i=1:length(SMrootModelName)
%     disp(i)
%     Event=load(['FlashDroughtEvent/' SMrootModelName{i}]);
%     TimingMat(:,:,i)=GetTiming(Event.FD.historical,date5d);
%     IntMat(:,:,i)=GetInt(Event.FD.historical,date5d,SMrootModelName{i});% Intensity
%     FDsDMat(:,:,i)=Event.FDsDMat.historical;
%     FDhc(:,:,i)=Event.FDhc.historical;
%     FDsNumMat(:,:,i)=Event.FDsNumMat.historical;
%     % MeanDur(:,:,i)=Event.FDhc./Event.FDsNumMat;
% end
% save Characteristic TimingMat FDsDMat FDhc FDsNumMat IntMat
load Characteristic
% clear Event IntMat FDsDMat FDhc FDsNumMat
% MeanDur=fill_land_gaps_nearest(MeanDur,~Aland);
% Fig.1c
% globalMap(mean(MeanDur,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,16,'r'),'clim',[4.5 8.5],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Duration [pentads/event]')
globalMap(mean(FDsDMat,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,16,'r'),'clim',[4.5 8.5],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Onset Duration [pentad]')
% [~,fqtj,IPCCRe]=globalMapIPCC1(mean(FDsDMat,3), latForm, lonForm,'region','IPCC','Math','mean','RGB',MatCM(94,16,'r'),'Projection','eckert3','shadow',maskpre,'ShowIPCCname',1,'remeth',"nearest",'climx',[4.5 8.5],'defaultsubplot',0,'TitleString','','ColorBarLabel','Onset Duration [pentad]');

% Intermodel differences in latitudinal distribution
PlotLonNew(FDsDMat,1,[4.5 8.5],5.98,false)

% Supplementary information
% 1. Frequency distribution
globalMap(mean(FDsNumMat,3)/65, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,16,'r'),'clim',[0 0.4],'Projection','pcarree','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Counts/yr')
PlotLonNew(FDsNumMat/65,1,[0 0.4],0.23,false)
% 2. Total number of drought pentads
FDhc=mask3(FDhc,~Aland);
globalMap(mean(FDhc,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(93,16,'r'),'clim',[20 180],'Projection','pcarree','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','pentads/ 65 yr')
PlotLonNew(FDhc,1,[20 180],94.8,false)
% % 3. Flash-drought timing
TimingMat=fill_land_gaps_nearest(TimingMat,~Aland);
globalMap(mode(TimingMat(:,:,14),3), latForm, lonForm,'clercmap',0,'RGB',MatCM(138,12,'r'),'clim',[0.5 12.5],'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString','Timing of Flash Drought','ColorBarLabel','[Month]')
PlotLonNew(TimingMat(:,:,[8 11 12 13 14]),1,[0.5 12.5],7,true)
for i=1:15% Intermodel differences in timing
    Tim=mode(TimingMat(:,:,i),3);
    GrowB=ismember(Tim(1:36,:),4:9);
    tim(i,1)=sum(GrowB,"all")/sum(~isnan(Tim(1:36,:)),"all")*100;
    GrowN=ismember(Tim(38:end,:),[10 11 12 1 2 3]);
    tim(i,2)=sum(GrowN,"all")/sum(~isnan(Tim(38:end,:)),"all")*100
end
% Percentage plot for the vegetation growing season
[tim(14,:)]
PlotPie([57.8 100-57.8], MatCM(92,2,'r'), [1])
PlotPie([61.7 100-61.7], MatCM(92,2,'r'), [1])

% 3. Mean intensity
IntMat=fill_land_gaps_nearest(IntMat,~Aland);
globalMap(median(IntMat(:,:,:),3), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12),'clim',[-8.5 -5.5],'Projection','pcarree','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Z-unit')%char(963)
PlotLonNew(IntMat,1,[-10 -4],-6.8,false)
% % Data reported in the table
% [IPCCRrg1,~]=popPlot(mean(FDsNumMat,3)/65,latFormX,lonFormX,'country');
% [IPCCRrg2,~]=popPlot(mean(FDhc,3),latFormX,lonFormX,'country');
% [IPCCRrg3,~]=popPlot(median(IntMat(:,:,:),3),latFormX,lonFormX,'country');
% MetrixIndex = RankMat([[IPCCRrg1.value]' [IPCCRrg2.value]' abs([IPCCRrg3.value]')]);


% %% 3. Supplementary analysis identifying precipitation and temperature as dominant controls
% % 1. Heatmap
% V{1}=load('CMIP6Data\DataSet_Pr_Mean.mat').pr;
% V{2}=load('CMIP6Data\DataSet_cape_ERA5.mat').cape;
% V{3}=load('CMIP6Data\DataSet_RH_ERA5.mat').RH;
% % V{4}=NWB;
% V{5}=load('CMIP6Data\DataSet_LCL_ERA5.mat').LCL;
% 
% V{6}=load('CMIP6Data\DataSet_Tmax_Mean.mat').tmax;
% V{7}=load('CMIP6Data\DataSet_Tmin_ERA5.mat').Tmin;
% V{8}=load('CMIP6Data\DataSet_t2m_ERA5.mat').t2m;
% V{9}=load('CMIP6Data\DataSet_VPD_ERA5.mat').VPD;
% V{10}=load('CMIP6Data\DataSet_ssrd_ERA5.mat').ssrd;
% V{11}=load('CMIP6Data\DataSet_wind10_ERA5.mat').wind10;
% V{12}=load('CMIP6Data\DataSet_STroot_ERA5.mat').STrootERA5;
% 
% V{13}=load('CMIP6Data\DataSet_E_GLEAM.mat').E;
% V{14}=load('CMIP6Data\DataSet_PET_Mean.mat').PET;
% V{15}=load('CMIP6Data\DataSet_lai_lv_ERA5.mat').lai_lv;
% V{16}=load('CMIP6Data\DataSet_sshf_ERA5.mat').sshf;
% V{17}=load('CMIP6Data\DataSet_slhf_ERA5.mat').slhf;
% 
% V{4}=V{1}-V{14};
% V{18}=load('CMIP6Data\DataSet_SMroot_Mean.mat').SMroot;
% vname={'Pr','CAPE','RH','NWB','LCL','T_{max}','T_{min}','T_{avg}','VPD','Ra','Wind','ST_{root}','E','PET','LAI','SHF','LHF','SM_{root}'};
% 
% LonLatInf=load('CMIP6Data/Coordinate.mat');
% Data3dStructureUser.lat=latForm;
% Data3dStructureUser.lon=lonForm';
% Data3dStructureForm.lat=LonLatInf.latForm;
% Data3dStructureForm.lon=LonLatInf.lonForm';
% for i=1:length(V)
%     % V{i} = ExAllSame3d(V{i});
%     Data3dStructureForm.data=V{i};
%     V{i}=ResampleMat(Data3dStructureUser,Data3dStructureForm,1);
% end
% V=cellfun(@(x) declimatologyNormalize(x,365),V,'UniformOutput',false);% Standardization
% lagt=[-50 -40 -30 -20 -10 0 10 20 30 40 50];
% for i=1:length(lagt)
%     disp(lagt(i))
%     Co1=cellfun(@(x) cor3d(x,V{end},lagt(i)),V(1:end-1),'UniformOutput',false);% Correlation coefficient
%     Co1=mask3(cat(3,Co1{:}),~Aland);
%     Comean(:,i)=squeeze(nanmedian(Co1,[1 2]));
% end
% 
% % Spatial distribution of correlation coefficients
% corPR_SM=cor3d(V{1},V{end},0);
% corTM_SM=cor3d(V{6},V{end},0);
% corRH_SM=cor3d(V{3},V{end},0);
% corVP_SM=cor3d(V{9},V{end},0);
% 
% save Lag-correlation Comean vname corPR_SM corTM_SM corRH_SM corVP_SM
load Lag-correlation
% Lag-correlation heatmap between environmental variables and root-zone soil moisture
plotHeatmap(Comean([1:11 13 14 15 17],:),arrayfun(@num2str,[-10 -8 -6 -4 -2 0 2 4 6 8 10],'UniformOutput',false),vname([1:11 13 14 15 17]),[-0.5 0.5],10)
% Correlation maps
clt=[-0.6 0.6001];
globalMap(corPR_SM, latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12,'r'),'clim',clt,'Projection','pcarree','region','IPCC','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Z-unit')%char(963)
globalMap(corTM_SM, latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12,'r'),'clim',clt,'Projection','pcarree','region','IPCC','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Z-unit')%char(963)
globalMap(corRH_SM, latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12,'r'),'clim',clt,'Projection','pcarree','region','IPCC','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Z-unit')%char(963)
globalMap(corVP_SM, latForm, lonForm,'clercmap',0,'RGB',MatCM(94,12,'r'),'clim',clt,'Projection','pcarree','region','IPCC','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Z-unit')%char(963)

% meanV=cellfun(@(x) squeeze(nanmedian(x,[1 2])),V([1:11 13 14 15 17 18]),'UniformOutput',false);
% meanV=[meanV{:}];

% Global-mean data for machine-learning analysis
% meanV=cat(2,meanV{:});
% save ML-TrainingData meanV vname -v6

%% 3. Classification of flash-drought events
%% Identify dominant types using root-zone soil moisture from multiple datasets
clc;clear;close all
SMrootModelName={'GDFC','GLDS','ERA5','Mean','AWI-ESM-1-1-LR','AWI-ESM-1-REcoM','CNRM-CM6-1','CNRM-ESM2-1','HadGEM3-GC31-LL','ICON-ESM-LR','IPSL-CM6A-LR','MPI-ESM-1-2-HAM','MPI-ESM1-2-HR','MPI-ESM1-2-LR','UKESM'};
SMsurfModelName={'GDFC','GLDS','ERA5','Mean','ACCESS-CM2','ACCESS-ESM1-5','AWI-ESM-1-1-LR','AWI-ESM-1-REcoM','BCC-CSM2-MR','BCC-ESM1','CanESM5','CNRM-CM6-1','CNRM-ESM2-1','HadGEM3-GC31-LL','ICON-ESM-LR','INM-CM4-8','INM-CM5-0','IPSL-CM6A-LR','MIROC6','MPI-ESM-1-2-HAM','MPI-ESM1-2-HR','MPI-ESM1-2-LR','MRI-ESM2-0','NorESM2-MM','UKESM1-0-LL'};

datehis=get_year_month_day(1950,2014,'noleap');
datehis5d=datehis(5:5:end,:);
datepro=get_year_month_day(2015,2100,'noleap');
datepro5d=datepro(5:5:end,:);
DateStr={datehis5d,datepro5d,datepro5d,datepro5d,datepro5d};% Date arrays used in structure-field loops
% PTGDFC=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_GLDAS.mat","PRpct5d","TApct5d",'ETpct5d');
% PTGLDAS=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_GDFC.mat","PRpct5d","TApct5d",'ETpct5d');
% PTERA5=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_ERA5.mat","PRpct5d","TApct5d",'ETpct5d');
% PTMean=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_Median.mat",'PRpct5d','TApct5d','ETpct5d');
SPI=load('StandardizedIndexSDI/SPI.mat','SPI_obs');
STI=load('StandardizedIndexSDI/STI.mat','STI_obs');
SEI=load('StandardizedIndexSDI/SEI.mat','SEI_obs');
SSI=load('StandardizedIndexSDI/SSI.mat','SSI_obs','SSI_gcm');
load Mask
load Coordinate
PT0=[-0.45 0.45];
for i=1:4
    Event=load(['FlashDroughtEvent/' SMrootModelName{i}]);
    [CAT_obs{i}, deta_obs{i}, NumYr_obs{i},P_obs{i},dSPI_obs{i},dSTI_obs{i},dSSI_obs{i},downx_obs{i},NumMon_obs{i}]=PTanom(Event.FD.historical,Event.downpmat.historical,SPI.SPI_obs{i},STI.STI_obs{i},SEI.SEI_obs{i},SSI.SSI_obs{i*2},PT0,nanindall,datehis5d);
end
for i=1:4
    Event=load(['FlashDroughtEvent/' SMsurfModelName{i}]);
    [CAT_obssurf{i}, deta_obssurf{i}, NumYr_obssurf{i},P_obssurf{i}]=PTanom(Event.FD.historical,Event.downpmat.historical,SPI.SPI_obs{i},STI.STI_obs{i},SEI.SEI_obs{i},SSI.SSI_obs{i},PT0,nanindall,datehis5d);
end

% Fig.1d
quaddata=deta_obs{3}(:,2:3);
quadrants1d(quaddata,0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);


RGB3=[215 48 31; 182 26 139;  41 118 184;33 140 33 ]/255;
colors=[227 74 51;197 27 138;49 130 189;49 163 84]/255;
stats_SMroot_GDFC=quadrants1d(deta_obs{1}(:,2:3),PT0(2),'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GDFC','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMroot_GLDAS=quadrants1d(deta_obs{2}(:,2:3),PT0(2),'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GLDAS','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMroot_Mean=quadrants1d(deta_obs{4}(:,2:3),PT0(2),'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GLDAS','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMroot_ERA5=quadrants1d(deta_obs{3}(:,2:3),0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);

stats_SMsurf_GDFC=quadrants1d(deta_obssurf{1}(:,2:3),PT0(2),'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GDFC','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMsurf_GLDAS=quadrants1d(deta_obssurf{2}(:,2:3),PT0(2),'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GLDAS','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
% Supplementary analysis using surface soil moisture
stats_SMsurf_ERA5=quadrants1d(deta_obssurf{3}(:,2:3),PT0(2),'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','ERA5','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);

% stats_SMroot_Mean=quadrants(deta_obs{4}(:,2:3),PT0,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation anomaly [' char(963) ']' ],'ylabel',['Temperature anomaly [' char(963) ']'] ,'FontSize',16);
stats_SMroot_Mean=quadrants1d(deta_obs{4}(:,2:3),0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation anomaly [' char(963) ']' ],'ylabel',['Temperature anomaly [' char(963) ']'] ,'FontSize',16);
stats_SMsurf_Mean=quadrants1d(deta_obssurf{4}(:,2:3),0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation anomaly [' char(963) ']' ],'ylabel',['Temperature anomaly [' char(963) ']'] ,'FontSize',16);

% SSP experiments, historical-to-future transitions, and ensemble statistics
load Dominanted.mat
pxSSP=[];
PT0=0.4;
for i=1:4
    for j=1:4
        stats_mod1{j}=quadrants1d(deta_gcm{i}{1}{j}(:,2:3),PT0,'show',0,'TitleString','Mean','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
        stats_mod2(:,:,j)=quadrants1d(deta_gcm{i}{2}{1}(:,2:3),PT0,'show',0,'TitleString','Mean','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
    end
    px=cat(3,stats_mod1{:});
    px=squeeze(px(:,end,:));
    pxSSP=[pxSSP px];
end

% Dominant types: ensemble mean and model-agreement map
meanstdall=[stats_SMroot_GDFC(:,end) stats_SMroot_GLDAS(:,end) stats_SMroot_ERA5(:,end) stats_SMroot_Mean(:,end) stats_SMsurf_GDFC(:,end) stats_SMsurf_GLDAS(:,end) stats_SMsurf_ERA5(:,end) stats_SMsurf_Mean(:,end) pxSSP];
% Fig. 1f. Uncertainty in type proportions across models
lentext={'Heatwave','Compound','Pre.deficit','Snow/cold','Normal'};
barmeanstd(meanstdall',[colors;0.85 0.85 0.85],lentext,'order', 1)
xlim([0 5])
yticks([0 10 20 30 40])
ylim([0 40])

ZD_obs=cellfun(@getZD,[CAT_obs CAT_obssurf],'UniformOutput',false);

ZDall=cat(3,ZD_obs{:});
ZDall=ZDall(:,:,[2 4 6 8]);
%% Fig. 1e. Modal class from model voting
ZDallmode=myapply(ZDall,3,@(x) mode(x));
% globalMap(ZDallmode, latForm, lonForm,'RGB',RGB3,'Projection','eckert3','region','IPCC','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')
% Univariate colour scale
% globalMapIPCC1(ZDallmode, latForm, lonForm,'region','IPCC','RGB',RGB3,'Math','mode','Projection','eckert3','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')
% Fig. 1e. Univariate colour scale with significance
nc=3;
RBG4lei={'orrd','rdpu','blues','greens'};% Colours for the four flash-drought types
ZDallnum=myapply(ZDall,3,@(x) sum(x == mode(x)));
RGBnc=[cbrewer2('seq', RBG4lei{1}, nc);cbrewer2('seq', RBG4lei{2}, nc);cbrewer2('seq', RBG4lei{3}, nc);cbrewer2('seq', RBG4lei{4}, nc)];
% globalMapIPCC1(ZDallmode, latForm, lonForm,'region','IPCC','RGB',RGBnc,'remeth',"bilinear",'Math','mode','defaultConf',ZDallnum,'defaultsubplot',0,'Projection','pcarree','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')
[hFig,IPCChatewave,IPCCprecdefict]=globalMapIPCC1tpye(ZDallmode, latForm, lonForm,'region','IPCC','RGB',RGBnc,'remeth',"bilinear",'Math','mode','defaultConf',ZDallnum,'defaultsubplot',0,'Projection','pcarree','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','','ColorBarLabel','');


% Extended Data Fig. 2: longer duration for precipitation-deficit events and shorter duration for heatwave-driven events
IPCCRe=shaperead('ShapData\IPCC-WGI-reference-regions-v4_shapefile\IPCC-WGI-reference-regions-v4.shp');
IPCCRrg=shap2mask(IPCCRe,latFormX,lonFormX);
date=get_year_month_day(1950,2014,"noleap");
date5d=date(5:5:end,:);
for i=1%:length(SMrootModelName)
    disp(i)
    Event=load('FlashDroughtEvent/Mean.mat','FDsDMat','FD');
    % Heatwave-driven type
    for j=1:length(IPCChatewave)
        EventD=Event.FDsDMat.historical;
        mask=IPCCRrg(ismember({IPCCRrg.Acronym},IPCChatewave{j})).mask;
        EventD(~mask)=nan;
        Int(~mask)=nan;
        MD.hatewave(i,j)=nanmean(EventD,"all");
    end
    % Precipitation-deficit type
    EventD=Event.FDsDMat.historical;
    Int=GetInt(Event.FD.historical,date5d,SMrootModelName{i});% Intensity
    for j=1:length(IPCCprecdefict)
        EventD=Event.FDsDMat.historical;
        mask=IPCCRrg(ismember({IPCCRrg.Acronym},IPCCprecdefict{j})).mask;
        EventD(~mask)=nan;
        MD.precdefict(i,j)=nanmean(EventD,"all");
    end
    % clear MD
end

% MD1=structfun(@mean,MD,'UniformOutput',false);
% Supplementary Fig.S4
heatVSPrep(MD.hatewave(2:14),MD.precdefict,IPCChatewave, IPCCprecdefict,13)
ylim([5  8])
xlim([0  22])

% Supplementary Fig.S4a
% [p,h,cohen_d]=WilcoxonSignedRankTest(MD.hatewave(2:14),MD.precdefict)
[p, h, Cliff_Delta] = WilcoxonRanksumTest(MD.hatewave(2:14),MD.precdefict);% Unequal sample sizes
Int=GetInt(Event.FD.historical,date5d,SMrootModelName{i});% Intensity
RGB1 = flip(cbrewer2('div', 'PIYG', 12, 'PCHIP'));
globalMap2IPCC(Event.FDsDMat.historical,Int, latForm, lonForm,'region','IPCC','RGB',MatCM(92,10),'Projection','pcarree','shadow',maskpre,'TitleString','Bi-scale Heatmap (Duration & Intensity)','ColorBarLabel','Mean duration [pentads·yr^{-1}]')


% IPCCRe=shaperead('ShapData\IPCC-WGI-reference-regions-v4_shapefile\IPCC-WGI-reference-regions-v4.shp');
% idx = strcmp({IPCCRe.Type}, 'Land') ;%| strcmp({IPCCRe.Type}, 'Land-Ocean');% Retain land regions
% IPCCRe=IPCCRe(idx);
% IPCCname={IPCCRe(:).Acronym};
% IPCCname={IPCCRe_meanDuration.Acronym};
load Characteristic
% clear Event IntMat FDsDMat FDhc FDsNumMat
% MeanDur=fill_land_gaps_nearest(MeanDur,~Aland);
% globalMap(mean(MeanDur,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,16,'r'),'clim',[4.5 8.5],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Duration [pentads/event]')
globalMap(mean(FDsDMat,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(94,16,'r'),'clim',[4.5 8.5],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Onset Duration [pentad]')
[~,fqtj,IPCCRe]=globalMapIPCC1(mean(FDsDMat,3), latForm, lonForm,'region','IPCC','Math','mean','RGB',MatCM(94,16,'r'),'Projection','eckert3','shadow',maskpre,'ShowIPCCname',1,'remeth',"nearest",'climx',[4.5 8.5],'defaultsubplot',0,'TitleString','','ColorBarLabel','Onset Duration [pentad]');
[tfhatewave, lochatewave] = ismember(IPCChatewave, IPCCname);
[tfprecdefi, locprecdefi] = ismember(IPCCprecdefict,IPCCname);
lochatewave = lochatewave(lochatewave > 0);
locprecdefi = locprecdefi(locprecdefi > 0);
valuehatewave=[fqtj(lochatewave).value];
valueprecdefi =[fqtj(locprecdefi).value];
ind1=[2 3 5 6 7 8 9 10 11 12 13 14];
% Supplementary Fig.S4b
heatVSPrep(valuehatewave(ind1),valueprecdefi,IPCCname(lochatewave(ind1)), IPCCname(locprecdefi),12)


% for i=1:length(SMrootModelName)
%     disp(SMrootModelName{i})
%     FDroot=load(['FlashDroughtEvent/' SMrootModelName{i}]);
%      [CmatSPI,CmatSTI]=FDcon(FDroot.FD.historical,SPI.SPI_obs{1},STI.STI_obs{1},SSI.SSI_obs{1});
%      [CmatSPI,CmatSTI]=FDconInd(SPI.SPI_obs{1},STI.STI_obs{1},SSI.SSI_obs{1});
%     inPre(:,:,i)=CmatSPI<CmatSTI;
% end
% inPrex=median(inPre,3);


% Fig. 2a. Separate panels for changes in type proportions
Fig2c={'oranges','rdpu','blues','greens'};% Colours for the four flash-drought types
RGBFig2=[cbrewer2('seq', Fig2c{1}, 4);cbrewer2('seq', Fig2c{2}, 4);cbrewer2('seq', Fig2c{3}, 4);cbrewer2('seq', Fig2c{4}, 4)];
nj=EnsLine(P_gcm,P_obs,1950:2100,1950:2014,RGBFig2); % 50-year moving mean suppresses high-frequency variability and reveals multidecadal hydrological trends
figure
mat1=nj{1,4};
plot(1950:2100,nj{1,1})
hold
plot(1950:2100,nj{2,1})
% Supplementary Fig. S11. Ridge plot of uncertainty in transition timing
[yr1, erx1, yr2, erx2, yr3, erx3, yr4, erx4] = pdfoneSSP(nj{1,1},nj{2,1},nj{1,2},nj{2,2},nj{1,3},nj{2,3},nj{1,4},nj{2,4});
% Stacked plot of changes in type proportions
% RGB3=cbrewer2('qual', 'Set1', 4);% Each row defines one RGB colour
% RGB3=[0.85 0.37 0.05; 0.13 0.55 0.13; 0.89 0.10 0.11; 0.16 0.44 0.74];
RGB3=[215 48 31; 182 26 139;  41 118 184;33 140 33 ]/255;
% RGB3=[252 141 89; 247 104 161; 116 196 118;  107 174 214]/255;% Lighter colours
RBG4lei={'orrd','rdpu','blues','greens'};% Colours for the four flash-drought types
RGB16=[cbrewer2('seq', RBG4lei{1}, 4);cbrewer2('seq', RBG4lei{2}, 4);cbrewer2('seq', RBG4lei{3}, 4);cbrewer2('seq', RBG4lei{4}, 4)];
hisv=linspace(1950,2014,65);
hisp=linspace(1950,2100,65+86);
Phis=P_obs{4};
for i=1:4
    proind=[3,4];
    for j=1:2
        pij(:,:,:,j)=P_gcm{i}{proind(j)};
    end
    pijx(:,:,i)=nanmean(pij,[3 4]);
    figure
    plot([Phis;nanmean(pij,[3 4])])
    ylim([0 0.6])
end
size(pijx)

clear pij

% Phis=mean(cat(3,P_SMroot_CanESM_QM_His,P_SMroot_MIROC6_QM_His,P_SMroot_IPSLCM_QM_His),3);
% portatiion=[Phis;mean(cat(3,P_SMroot_CanESM_QM_Pro,P_SMroot_MIROC6_QM_Pro,P_SMroot_IPSLCM_QM_Pro),3)];
% sspxf=mean(P_gcm{1}{4},3);
% Supplementary analysis of climate-mitigation potential
size(P_gcm{1}{4})
mas=[];
for i=1:4
    portatiion=[Phis;pijx(:,:,i)];
    portatiion=movmean(portatiion(1:5:end,:),5,1);
    % plot([portatiion])
    barstack(hisp(1:5:end), portatiion*100,slanCL(699),[lentext {''}])
    % xticks([1950:10:2100])
    % Add significance tests
    masi=squeeze(pijx(:,i,:))*100;
    for j=1:3
        [pw(i,j),hw(i,j),cohen_d(i,j)]=WilcoxonSignedRankTest(masi(:,1),masi(:,j+1));
    end
     % [pw(i),hw(i),cohen_d(i)]=WilcoxonRanksumTest(masi(:,1),masi(:,end));
    mas=[mas masi];
end
% clear pw hw cohen_d mas
% Supplementary Fig. S6. Comparison with unadjusted data
boxchart(mas);

%% Fig. 3a. Three stages of change in dominant flash-drought type
stage(Phis,pijx,hisp,RGB16)
for s=2:4
    % s=2;
    stageDiv(Phis,pijx(:,:,s),hisp,colors)
    A=squeeze(pijx(:,1,s));A=movmean(A,5,1);
    B=squeeze(pijx(:,2,s));B=movmean(B,5,1);
    sign_changes = diff(sign(A-B));
    dATP=2015:2100;
    yrx(s)=dATP(sign_changes~=0);
end
plot([A B])
yrx;


%% Changes in each flash-drought type and in total event count
ExperimentID={'historical','ssp126','ssp245','ssp370','ssp585'};
runx(NumYr_gcm,RGB16,hisp)
% k=1;
% for i=1:length(SMrootModelName)
%     disp(i)
%     FDroot=load(['FlashDroughtEvent/' SMrootModelName{i}]);
%     Fieldname=fieldnames(FDroot.FD);
%     if all(ismember(ExperimentID,Fieldname))
%         Fra=GetChaNum(FDroot.FD,DateStr);
%         FDsNumMat=structfun(@(x) squeeze(nansum(x,[1 2])),Fra,'UniformOutput',false);
%         FDsHis(:,k)=FDsNumMat.historical;
%         FDsPr1(:,k)=FDsNumMat.ssp126;
%         FDsPr2(:,k)=FDsNumMat.ssp245;
%         FDsPr3(:,k)=FDsNumMat.ssp370;
%         FDsPr4(:,k)=FDsNumMat.ssp585;
%         k=k+1;
%     end
% end
% 
% PlotLineRange(hisv,FDsHis,[10 90],MatCM(55,121,'r'),1)
% hold on
% PlotLineRange([2015:2100],FDsPr1,[10 90],MatCM(55,121,'r'),0.1)
% PlotLineRange([2015:2100],FDsPr2,[10 90],MatCM(55,121,'r'),0.3)
% PlotLineRange([2015:2100],FDsPr3,[10 90],MatCM(55,121,'r'),0.6)
% PlotLineRange([2015:2100],FDsPr4,[10 90],MatCM(55,121,'r'),0.9)
%% Figs. 2b,d and Supplementary Fig. S9. Spatial changes in event counts by type during 2036-2100 relative to 1950-2014: (Pfuture - Ppast) / Ppast * 100%
% Fig.2b Fig.2d
CAT_obshis=squeeze(nansum(CAT_obs{4},3));%CAT_obshis(CAT_obshis==0)=nan;% Historical baseline, 1950-2014
RGBincrs1 = cbrewer2('seq', 'orrd', 12, 'PCHIP');
RGBincrs2 = cbrewer2('seq', 'rdpu', 12, 'PCHIP');
RGBdecrs3 = flip(cbrewer2('seq', 'greens', 12, 'PCHIP'));
RGBdecrs4 = flip(cbrewer2('seq', 'blues', 12, 'PCHIP'));
RGBcel={RGBincrs1,RGBincrs2,RGBdecrs4,RGBdecrs3};
% RGBcel={MatCM(94,12),MatCM(94,12),MatCM(94,12),MatCM(94,12)};

Tlim={[0 30],[0 30],[-30 0],[-30 0]};
% Tlim={[0 30],[0 30],[-30 0],[-30 0]};
TitleString={'Increased heatwave-driven','Increased compound-intensified','Reduced precipitation-deficit','Reduced cold/snow-induced'};
for s=1:4
    % Historical and future event counts for four types under scenario s
    CAT_his=CAT_gcm{s}{1}+CAT_gcm{s}{2};CAT_his=squeeze(mean(CAT_his,1));CAT_his=squeeze(sum(CAT_his,3));
    CAT_pro=CAT_gcm{s}{3}+CAT_gcm{s}{4};CAT_pro=squeeze(mean(CAT_pro,1));CAT_pro=squeeze(sum(CAT_pro(:,:,end-65+1:end,:),3));
    
    chnge=(CAT_pro-CAT_his);%./CAT_his*100;% Historical-to-future changes in counts for four types
    chnge(chnge==0)=nan;
    ind=~isnan(sum(chnge,3));
    for i=1:4
        chngei=chnge(:,:,i);
        if s==1%%:SSPn% SSP1-2.6 is shown in the main figure despite its increase; SSP5-8.5, with a larger increase, is shown in the supplement
            % globalMap(chnge(:,:,i), latForm, lonForm,'clercmap',0,'RGB',RGBcel{i},'clim',Tlim{i},'Projection','eckert3','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]')%char(963)
           [~,~]=globalMapIPCC1(chnge(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',Tlim{i},'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]');
           % [~,CountHist{i}]=globalMapIPCC1(CAT_his(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',Tlim{i},'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]');
           % [~,CountProj{i}]=globalMapIPCC1(CAT_pro(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',Tlim{i},'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]');
           % 
           % [~,CountHist{i}]=globalMapIPCC1(CAT_his(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]');
           %  [~,CountProj{i}]=globalMapIPCC1(CAT_pro(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]')
        end
    end
    chnge1=chnge(:,:,1);
    chnge2=chnge(:,:,2);
    chnge3=chnge(:,:,3);
    chnge4=chnge(:,:,4);
    DatSap=[ chnge1(ind) chnge2(ind) chnge3(ind) chnge4(ind) ];
    co=corr(DatSap,'Type','Spearman');
    comat(s,:)=co(1,:);
end

SSPname  = {'126','245','370','585'};
PlotSSPBar(cbrewer2('seq', RBG4lei{2}, 4), SSPname);
% Grouped bar chart
% Supplementary Fig.S10
PlotGroupBar(comat(:,2:end)', RGB16(5:end,:), {'Cor(H,C)','Cor(H,P)','Cor(H,S)'});
ylabel("Spearman's ρ",'FontWeight','bold')
mean(comat)% Final entry


ind=~isnan(sum(chnge,3));
chnge1=chnge(:,:,1);
chnge2=chnge(:,:,2);
chnge3=chnge(:,:,3);
chnge4=chnge(:,:,4);
DatSap=[ chnge2(ind) chnge3(ind) chnge4(ind) chnge1(ind)];
C = Contribution(DatSap, 'std');
mas=[];
for s=1:4
    % [c,r]=corr(DatSap,'Type','Spearman');
    CAT_his=CAT_gcm{s}{1}+CAT_gcm{s}{2};CAT_his=squeeze(mean(CAT_his,1));
    CAT_pro=CAT_gcm{s}{3}+CAT_gcm{s}{4};CAT_pro=squeeze(mean(CAT_pro,1));
    CAT_pro=cat(3,CAT_his,CAT_pro);
    % chnge=(CAT_pro-CAT_his);
    CAT_pro=fillmissing(CAT_pro,"linear",3);
    [Co1,Pa]=cor3d(CAT_pro(:,:,:,1),CAT_pro(:,:,:,2));
    [Co2,Pa]=cor3d(CAT_pro(:,:,:,1),CAT_pro(:,:,:,3));
    [Co3,Pa]=cor3d(CAT_pro(:,:,:,1),CAT_pro(:,:,:,4));
    [C,R]=Contribution3d(CAT_pro,'std');
    % R(R==0)=nan;
    if s==1
        Co3= fill_land_gaps_nearest(Co3,maskpre);
        Co3(~Aland)=nan;
        % globalMap(Co1, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,12,'R'),'clim',[-0.3 0.3],'Projection','eckert3','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]')%char(963)
        % globalMap(Co2, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,12,'R'),'clim',[-0.3 0.3],'Projection','eckert3','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]')%char(963)
        % globalMap(Co3, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,12,'R'),'clim',[-0.2 0.2],'Projection','eckert3','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]')%char(963)
        % globalMap(C(:,:,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(92,12,'R'),'climx',[0 1],'Projection','pcarree','region','IPCC','ShowIPCCname',0,'shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel',"Spearman's ρ")%char(963)
        globalMapIPCC1(C(:,:,3), latForm, lonForm,'region','IPCC','Math','mean','RGB',MatCM(92,10,'r'),'climx',[0 1],'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'TitleString','','ColorBarLabel','Contribution [stand.]')
        % [~,CountHist{i}]=globalMapIPCC1(CAT_his(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',Tlim{i},'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]');
        % [~,CountProj{i}]=globalMapIPCC1(CAT_pro(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',Tlim{i},'Projection','eckert3','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','Change of Count [times·65yr^{-1}]');
        % 
        % [~,CountHist{i}]=globalMapIPCC1(CAT_his(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]');
        %  [~,CountProj{i}]=globalMapIPCC1(CAT_pro(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]')

        % globalMapIPCC1(R, latForm, lonForm,'region','IPCC','Math','mean','RGB',MatCM(92,12,'r'),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'TitleString','','ColorBarLabel','Contribution [stand.]')
    end
    mas(end+1,:)=[nanmedian(Co1,'all') nanmedian(Co2,'all') nanmedian(Co3,'all')];
end

% corr3(CAT_his(:,:,:,1),CAT_his(:,:,:,2));

CAT_his=squeeze(sum(CAT_gcm{s}{1}+CAT_gcm{s}{2},4));
CAT_pro=CAT_gcm{s}{3}+CAT_gcm{s}{4};
CAT_pro=squeeze(sum(CAT_pro(:,:,:,end-65+1:end,:),4));
chnge=(CAT_pro-CAT_his);%./CAT_his*100;
chnge(chnge==0)=nan;
chnge=permute(chnge,[2 3 1 4]);
% Latitudinal distribution
PlotLonNew(chnge(:,:,:,1),5,[-10 50],8.4,true)
PlotLonNew(chnge(:,:,:,3),5,[-28 3],-7,true)
% Latitudinal distribution
PlotLonNew(chnge(:,:,:,2),5,[-5 30],6.8,true)
PlotLonNew(chnge(:,:,:,4),5,[-30 10],-6.6,true)

% 
% % Fig.2f
% CountHistHeatwave=CountHist{1};
% CountHistCompound=CountHist{2};
% CountProjHeatwave=CountProj{1};
% CountProjCompound=CountProj{2};
% PlotHistProj(CountHistHeatwave,CountHistCompound,CountProjHeatwave,CountProjCompound)
% 
% HeatwaveFlashDrought=fqtj{1};
% CompoundFlashDrought=fqtj{2};
% 
% 
% clear CountHist CountProj



% Fig. 3b. Sankey diagram
size(CAT_gcm{4}{1})
CAT_gcm{4}{1}(CAT_gcm{4}{1}==0)=nan;
CAT_gcm{4}{2}(CAT_gcm{4}{2}==0)=nan;
CAT_gcm{4}{3}(CAT_gcm{4}{3}==0)=nan;
CAT_gcm{4}{4}(CAT_gcm{4}{4}==0)=nan;

CAT585=squeeze(sum(cat(4,cat(6,CAT_gcm{4}{1},CAT_gcm{4}{2}),cat(6,CAT_gcm{4}{3},CAT_gcm{4}{4})),[1 6],'omitnan'));% Modal response across SSP5-8.5 models and ensemble members
size(CAT585)
% Divide the record into three stages

gapy=[1995,2070];
yr=1950:2100;
gapy1=find(yr==gapy(1)==1);
gapy2=find(yr==gapy(2)==1);

CAT585i1=squeeze(nansum(CAT585(:,:,1:gapy1,:),3));%1950-200
CAT585i2=squeeze(nansum(CAT585(:,:,gapy1+1:gapy2,:),3));%1950-200
CAT585i3=squeeze(nansum(CAT585(:,:,gapy2+1:151,:),3));%1950-200
colors = cbrewer2('qual', 'Paired', 8);
% colors = colors([8 6 2 4],:);
colors=[227 74 51;197 27 138;49 130 189;49 163 84]/255;
[stage_type_ratios, flow_percentages]=plotSankeyFlashDrought(CAT585i1,CAT585i2,CAT585i3,colors)

sum(flow_percentages{2},1)

% Fig. 2e. Circular plot
for i=1:4
    NumMonGcm{i}=[(NumMon_gcm{i}{1}+NumMon_gcm{i}{2})/2;(NumMon_gcm{i}{3}+NumMon_gcm{i}{4})/2];
end
NumMonGcm=cat(3,NumMonGcm{:});
NumMonGcm=mean(NumMonGcm,3);
dg=NumMonGcm(:,1:3);
dgx=NumMonGcm(:,end-3:end);
RGBloop=colors([3 4 2 1],:);
RGBloop(end,:)=[255 127 0]/255;
% plotdrought(NumMon_obs{1, 4}(:,1:2), NumMon_obs{1, 4}(:,4))
plotdroughtMulti(dg, dgx(:,[3 4 2 1]),{'c'})% Multivariate rings from inner to outer: precipitation deficit, offset, compound, and heatwave
plotdroughtMultioroginal(dg, dgx(:,[3 4 2 1]),{'c'})% Multivariate rings from inner to outer: precipitation deficit, offset, compound, and heatwave


% Fig. 3c. Exposed area
% Fig. 3. Exposed area and onset speed
load('Mask.mat')
load("Coordinate.mat")
SSP={'126','245','370','585'};
A = cdtarea(latFormX,lonFormX,'km2');
A_land=mask3(A,~island(latFormX,lonFormX));

%% Metric 1. Global land area
totalArea=nansum(A_land,'all');
[~,Are_obs,Arec_obs,pa_obs,V_obs,~]= cellfun(@(down,nanind,A,A_land) expose(down,nanind,A,A_land),downx_obs, repmat({nanindall}, 1, 4),repmat({A}, 1, 4),repmat({A_land}, 1, 4),'UniformOutput', false);
for i=1:4
    disp(SSP{i})
    [~,Are_gcm{i},Arec_gcm{i},pa_gcm{i},V_gcm{i},droLog{i}]= cellfun(@(down,nanind,A,A_land) expose(down,nanind,A,A_land),downx_gcm{i}, repmat({nanindall}, 1, 4),repmat({A}, 1, 4),repmat({A_land}, 1, 4),'UniformOutput', false);
end
k=1;
textx={'Pre.deficit-Driven','Compound-Intensified','Heatwave-Driven'};
RGB12=[cbrewer2('seq', RBG4lei{3}, 4);cbrewer2('seq', RBG4lei{2}, 4);cbrewer2('seq', RBG4lei{1}, 4)];
texB={'','',''};% Values determined from proportions of global population
for i=1
    for s=1:4
        ENScatEns1=cat(1,Are_gcm{s}{1},Are_gcm{s}{3});% Two large models
        ENScatEns2=cat(1,Are_gcm{s}{2},Are_gcm{s}{4});
        ENScatEns=cat(2,ENScatEns1,ENScatEns2);% 151 years, four types, and five ensemble members times the number of large models
        ENS1modEns=squeeze(ENScatEns(:,:,i));% 151-year series
        stag1=nanmean(ENS1modEns(1:46,:));% Mean annual exposed area across periods of 46, 75, and 30 years
        stag2=nanmean(ENS1modEns(47:121,:));
        stag3=nanmean(ENS1modEns(122:151,:));
        stag(:,:,s)=[stag1' stag2' stag3'];% 10 rows by 3 columns
    end
    pc=barexposedarea(stag,RGB12,{'Pre.deficit-Era','Compound-Era','Heatwave-Era'},totalArea,texB);
    % ylim([0 10*10^6])
    ylabel('Exposed Area [km^{2}]')
end
% barexposedareaRegin(pc,MatCM(92,144,'r'),{'ssp1-2.6','ssp2-4.5','ssp3-7.0','ssp5-8.5'},123,{'1.2%','3.0%','5.2%','45'})
barexposedarea(pc,RGB12,{'Pre.deficit-Era','Compound-Era','Heatwave-Era'},totalArea,texB);
ylabel('Proportion of exposed area [%]')

 % barexposedareaRegin(pc,MatCM(92,144,'r'),{'ssp1-2.6','ssp2-4.5','ssp3-7.0'},123,{'1.2%','3.0%','5.2%','45'})
    

%% Metric 2. Global population in 2020 for proportional exposure estimates
popmat=load('ShapData\ORNL-2.5 ° Global Population Grid Data.mat');% Unit: persons
totalPop=nansum(popmat.PopR,'all');% Total population: 7.6 billion
for i=1:4
    disp(SSP{i})
    % [~,Pop_gcm{i},Popc_gcm{i},Poppa_gcm{i},PopV_gcm{i}]= cellfun(@(down) expose(down,nanindall,popmat.PopR,A_land),downx_gcm{i},'UniformOutput', false);
    [~,~,Pop_gcm{i},~,~,~]= cellfun(@(down) expose(down,nanindall,A_land,popmat.PopR),downx_gcm{i},'UniformOutput', false);
end
[droLog1,droLog2,droLog3,Ax,Aimean]=GetNumERA(droLog,A,totalArea);


globalMap(droLog1, latForm, lonForm,'clercmap',0,'RGB',MatCM(15,10),'clim',[0 30],'Projection','robinson','shadow',maskpre,'point',~isnan(droLog1)&droLog1~=0,'defaultsubplot',1,'TitleString','','ColorBarLabel','Affected area')%char(963)
globalMap(droLog2, latForm, lonForm,'clercmap',0,'RGB',MatCM(15,10),'clim',[0 30],'Projection','robinson','shadow',maskpre,'point',~isnan(droLog2)&droLog2~=0,'defaultsubplot',1,'TitleString','','ColorBarLabel','Affected area')%char(963)
globalMap(droLog3, latForm, lonForm,'clercmap',0,'RGB',MatCM(15,10),'clim',[0 10],'Projection','robinson','shadow',maskpre,'point',~isnan(droLog3)&droLog3~=0,'defaultsubplot',1,'TitleString','','ColorBarLabel','Heatwave-Flash drought [counts]')%char(963)

% clear Pop_gcm
texB={'1.2%','3.0%','5.2%'};
for i=1
    for s=1:4
        ENScatEns1=cat(1,Pop_gcm{s}{1},Pop_gcm{s}{3});% Two large models
        ENScatEns2=cat(1,Pop_gcm{s}{2},Pop_gcm{s}{4});
        ENScatEns=cat(2,ENScatEns1,ENScatEns2);% 151 years, four types, and five ensemble members times the number of large models
        ENS1modEns=squeeze(ENScatEns(:,:,i));% 151-year series
        stag1=nanmean(ENS1modEns(1:46,:));% Mean annual exposure across periods of 46, 75, and 30 years
        stag2=nanmean(ENS1modEns(47:121,:));
        stag3=nanmean(ENS1modEns(122:151,:));
        stag(:,:,s)=[stag1' stag2' stag3'];% 10 rows by 3 columns
    end
    barexposedarea(stag,RGB12,{'Pre.deficit-Era','Compound-Era','Heatwave-Era'},totalPop,texB)
    % ylim([0 10*10^6])
    ylabel('Exposed Pop [pop]')
end

for s=4
    % s=1
    CAT_his=CAT_gcm{s}{1}+CAT_gcm{s}{2};CAT_his=squeeze(mean(CAT_his,1));CAT_his=squeeze(sum(CAT_his,3));
    CAT_pro=CAT_gcm{s}{3}+CAT_gcm{s}{4};CAT_pro=squeeze(mean(CAT_pro,1));CAT_pro=squeeze(sum(CAT_pro,3));
    Numpro=sum(CAT_pro,3)>86/2;
    % see3d(CAT_pro)
end
% Supplementary Fig. S12. Population exposed in 2022
globalMap(popmat.PopR, latForm, lonForm,'clercmap',0,'RGB',MatCM(161,255),'Projection','pcarree','shadow',maskpre,'point',Numpro,'defaultsubplot',0,'TitleString','','ColorBarLabel','Population in 2022')%char(963)

%Fig.3d onset speed of flash drought
mvwin=5;
onesetspeed(V_gcm,mvwin,hisp,MatCM(55,121,'r'))%55(r),64,54,56, Fig.3d
onesetspeed_org(V_gcm,mvwin,hisp,RGB16)
Ev=load('FlashDroughtEvent/IPSL-CM6A-LR.mat');
yrlen={1950:2014,2015:2100,2015:2100,2015:2100,2015:2100};
ModeSp=nan(15,5,121,'single');
st=[1 66 66 66 66];
for i=1:length(SMrootModelName)
    disp(SMrootModelName{i})
    Ev=load(['FlashDroughtEvent/' SMrootModelName{i} '.mat'],'FD','downpmat');
    Fieldname=fieldnames(Ev.FD);
    YesEX=ismember(ExperimentID,fieldnames(Ev.FD));
    for j=1:length(YesEX)
        if YesEX(j)
            EvFD=Ev.FD.(ExperimentID{j});
            % EvSpeed=Ev.downpmat.(ExperimentID{j});
            [m,n]=size(EvFD);
            yrij=yrlen{j};
            YrDur=nan(length(yrij),m,n,100,'single');
            for ii=1:m
                for jj=1:n
                    if iscell(EvFD{ii,jj})&length(EvFD{ii,jj})~=0
                        FDiijj=EvFD{ii,jj};
                        Dur=cellfun(@length,FDiijj,'UniformOutput',true);
                        % YrDur(yesIND,ii,jj)=mean(Dur);
                        % length([FDiijj{:}])
                        % Speediijj=EvSpeed{ii,jj};
                        for kk=1:length(FDiijj)
                            ind=FDiijj{kk};
                            yr=mode(DateStr{j}(ind,1));
                            yesIND=yrij==yr;
                            YrDur(yesIND,ii,jj,kk)=Dur(kk);
                        end
                    end
                end
            end
            SpeedExp=nanmean(YrDur,[2 3 4]);
            ModeSp(i,j,st(j):st(j)+length(yrlen{j})-1)=SpeedExp;
        end
    end
end
clear SpeedExp
plot(squeeze(ModeSp(:,1,:))')
hold on
plot(squeeze(ModeSp(:,2,:))')
ylim([5 7])
plot(squeeze(ModeSp(:,3,:))')
plot(squeeze(ModeSp(:,4,:))')


% Temperature increases by one standard deviation during drought events
% Fig. 4d. Precipitation and temperature anomalies
% Supplementary Fig. S14. Soil moisture and evapotranspiration
RGB5={'',cbrewer2('seq', 'blues', 4),cbrewer2('seq', 'orrd', 4),cbrewer2('seq', 'greens', 4),cbrewer2('seq', 'RDPU', 4)};
% sgmaPTSMET(deta_gcm,RGB4)
sgmaPTSMET(deta_gcm,RGB5)


% Fig. 4b. Future change in the annual climatological soil-moisture buffer
SSP={'126','245','370','585'};
brbg=flip(cbrewer2('div', 'brbg', 16, 'PCHIP'));
spectral=flip(cbrewer2('div', 'spectral', 8, 'PCHIP'));
piyg=flip(cbrewer2('div', 'piyg', 16, 'PCHIP'));
prgn=flip(cbrewer2('div', 'prgn', 8, 'PCHIP'));
rdylbu=cbrewer2('div', 'rdylbu', 16, 'PCHIP');
rdgy=flip(cbrewer2('div', 'rdgy', 16, 'PCHIP'));
% ET
for i=1:4
    disp(i)
    % 1. Soil moisture
    mod1=load(['CMIP6Data/CanESM5_SMpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['CMIP6Data/IPSLCM6_SMpct5d_SSP' SSP{i} '.mat']);
    % Historical 65-year period
    SMhis=squeeze(mean((mod1.His+mod2.His)/2,1));
    SMclimHis=mean(SMhis,3);% Climatology
    SM20th=prctile(SMhis,20,3);% Drought threshold
    % Annual future values
    SMPro=squeeze(mean((mod1.Pro+mod2.Pro)/2,1));
    SMPro65=reshape(SMPro,61,144,73,[]);
    SMProyrmean=squeeze(mean(SMPro65,3));
    gapBF(:,:,:,i)=(SMProyrmean-SM20th)./SM20th*100*10;% Change per decade
    [tr(:,:,i),sp(:,:,i)]=trend(gapBF(:,:,:,i));
    pmkSM(:,:,i)=mann_kendall(gapBF(:,:,:,i),0.01);

    % 2. Evapotranspiration
    mod1=load(['CMIP6Data/CanESM5_ETpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['CMIP6Data/IPSLCM6_ETpct5d_SSP' SSP{i} '.mat']);
    % Historical 65-year period
    EThis=squeeze(mean((mod1.His+mod2.His)/2,1));
    ETclimHis=mean(EThis,3);% Climatology
    % Annual future values
    ETPro=squeeze(mean((mod1.Pro+mod2.Pro)/2,1));
    ETPro65=reshape(ETPro,61,144,73,[]);
    ETProyrmean=squeeze(mean(ETPro65,3));
    gap=(ETProyrmean-ETclimHis)./ETclimHis*100*10;
    [trET(:,:,i),spET(:,:,i)]=trend(gap);
    pmkET(:,:,i)=mann_kendall(gap,0.01);
end
trmean=median(tr,3);
spall=sum(pmkSM,3)==4;
trmean(isoutlier(trmean))=nan;
trETmean=median(trET,3);
spETall=sum(pmkET,3)==4;
% trETmean(isoutlier(trETmean))=nan;
% Fig. 4b. Regions with a declining soil-moisture buffer
globalMap(trmean, latForm, lonForm,'clercmap',0,'RGB',rdylbu,'Projection','eckert3','shadow',maskpre,'climx',[-0.8 0.8],'point',spall,'defaultsubplot',0,'TitleString','','ColorBarLabel','slop [% 10yr^{-1}]')
% globalMap(trETmean, latForm, lonForm,'clercmap',0,'RGB',brbg,'climx',[-4 4],'Projection','eckert3','shadow',maskpre,'point',spETall,'defaultsubplot',0,'TitleString','','ColorBarLabel','slop [% 10yr^{-1}]')
% Supplementary-information version
% globalMap(trETmean, latForm, lonForm,'clercmap',0,'RGB',brbg,'climx',[-4 4],'Projection','pcarree','shadow',maskpre,'point',spETall,'defaultsubplot',0,'TitleString','','ColorBarLabel','slop [% 10yr^{-1}]')

% Supplementary Fig. S15. Threshold sensitivity
TrSM=BufferSSP([5:1:40]);
globalMap(TrSM(:,:,4,1), latForm, lonForm,'clercmap',0,'RGB',rdylbu,'Projection','eckert3','shadow',maskpre,'climx',[-0.8 0.8],'point',spall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
Regin={{[36 53],[-130 -50]},{[33 74],[-12 60]},{[24 35],[90 122]},{[-43 -10],[112 154]},{[-37 -11],[8 41]},{[-58 12],[-83 -34]},{[-4 15],[12 50]},{[5 20],[72 87]}};
texB={'1.2%','3.0%','5.2%'};
for i=1:length(Regin)
    TrSMr=TrSM;
    mask = geomask(latFormX,lonFormX,Regin{i}{1},Regin{i}{2});
    maskr=repmat(mask,[1 1 4 36]);
    TrSMr(~maskr)=nan;
    dat=squeeze(nanmean(TrSMr,[1 2]));
    dat=repmat(dat,[1 1 2]);
    dat=permute(dat,[3 1 2]);
    barexposedareaRegin(dat,MatCM(92,144,'r'),{'ssp1-2.6','ssp2-4.5','ssp3-7.0','ssp5-8.5'},123,{'1.2%','3.0%','5.2%','45'})
    ylabel('[%/yr]')
end

% PET
% 2. Potential evapotranspiration, VPD, and precipitation
PET=load('ModelMean\MeanPE.mat').MeanPE;
% Historical 65-year period
PEThis=PET.historical;
PETclimHis=mean(PEThis,3);% Climatology

VPD=load('ModelMean\MeanVP.mat').MeanVP;
% Historical 65-year period
VPThis=VPD.historical;
VPDclimHis=mean(VPThis,3);% Climatology
Pr=load('ModelMean\MeanPr.mat').MeanPr;
% Historical 65-year period
Prhis=Pr.historical;
PrclimHis=mean(Prhis,3);% Climatology
ET=load('ModelMean\MeanET.mat').MeanET;
% Historical 65-year period
EThis=ET.historical;
ETclimHis=mean(EThis,3);% Climatology

for i=1:4
    disp(i)
    % 1. VPD
    VPDPro=VPD.(['ssp' SSP{i}]);
    VPDPro86=reshape(VPDPro,61,144,73,[]);
    VPDroyrmean=squeeze(mean(VPDPro86,3));
    gapVPD(:,:,:,i)=(VPDroyrmean-VPDclimHis)./VPDclimHis*100*10;
    [trVPD(:,:,i),spVPD(:,:,i)]=trend(gapVPD(:,:,:,i));
    pmkVPD(:,:,i)=mann_kendall(gapVPD(:,:,:,i),0.01);

    % 2. Annual future PET
    PETPro=PET.(['ssp' SSP{i}]);
    PETPro86=reshape(PETPro,61,144,73,[]);
    PETProyrmean=squeeze(mean(PETPro86,3));
    gapPET(:,:,:,i)=(PETProyrmean-PETclimHis)./PETclimHis*100*10;
    [trPET(:,:,i),spPET(:,:,i)]=trend(gapPET(:,:,:,i));
    pmkPET(:,:,i)=mann_kendall(gapPET(:,:,:,i),0.01);
    % 3. Annual future precipitation
    PrPro=Pr.(['ssp' SSP{i}]);
    PrPro86=reshape(PrPro,61,144,73,[]);
    PrProyrmean=squeeze(mean(PrPro86,3));
    gapPr(:,:,:,i)=(PrProyrmean-PrclimHis)./PrclimHis*100*10;
    [trPr(:,:,i),spPr(:,:,i)]=trend(gapPr(:,:,:,i));
    pmkPr(:,:,i)=mann_kendall(gapPr(:,:,:,i),0.01);
    % 4. Annual future evapotranspiration
    ETPro=ET.(['ssp' SSP{i}]);
    ETPro86=reshape(ETPro,61,144,73,[]);
    ETProyrmean=squeeze(mean(ETPro86,3));
    gapET(:,:,:,i)=(ETProyrmean-ETclimHis)./ETclimHis*100*10;
    [trET(:,:,i),spET(:,:,i)]=trend(gapET(:,:,:,i));
    pmkET(:,:,i)=mann_kendall(gapET(:,:,:,i),0.01);
end

trPETmean=mean(trPET,3);
spPETall=sum(pmkPET,3)==4;
trVPDmean=mean(trVPD,3);
spVPDall=sum(pmkVPD,3)==4;
trPrmean=mean(trPr,3);
spPrall=sum(pmkPr,3)==4;
trETmean=mean(trET,3);
spETall=sum(pmkET,3)==4;
% trETmean(isoutlier(trETmean))=nan;

globalMap(trPrmean, latForm, lonForm,'clercmap',0,'RGB',brbg,'Projection','eckert3','shadow',maskpre,'climx',[-8 8],'point',spPrall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
globalMap(trETmean, latForm, lonForm,'clercmap',0,'RGB',brbg,'Projection','eckert3','shadow',maskpre,'climx',[-8 8],'point',spETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
% Supplementary Fig. S16
globalMap(trPETmean, latForm, lonForm,'clercmap',0,'RGB',MatCM(55,16,'R'),'Projection','pcarree','shadow',maskpre,'climx',[0 4],'point',spPETall,'defaultsubplot',1,'TitleString','','ColorBarLabel','slop [% /10yr]')
PlotLonNew(trPET,1,[0 4],1.65,true)
% globalMap(trVPDmean, latForm, lonForm,'clercmap',0,'RGB',MatCM(17,12),'Projection','pcarree','shadow',maskpre,'climx',[0 12],'point',spVPDall,'defaultsubplot',1,'TitleString','','ColorBarLabel','slop [% /10yr]')
% Fig.4c
globalMap(trVPDmean, latForm, lonForm,'clercmap',0,'RGB',MatCM(17,12),'Projection','eckert3','shadow',maskpre,'climx',[0 12],'point',spVPDall,'defaultsubplot',0,'TitleString','','ColorBarLabel','slop [% 10yr^{-1}]')

PlotLonNew(trVPD,1,[0 12],4.3,true)

% save MeteForcing-Trend tr trET trPET trVPD trPr
load MeteForcing-Trend
% globalMap(trVPDmean, latForm, lonForm,'clercmap',0,'RGB',NclCM(71,12),'Projection','pcarree','shadow',maskpre,'climx',[0 12],'defaultsubplot',0,'TitleString','','ColorBarLabel','slop [% /10yr]')

% Results from two alternative PET formulations
% Supplementary Fig. S17
[trPETHSmean,spPETHSall,trPETHS]=OtPET('ModelMean/MeanPEHS.mat','MeanPEHS');
[trPETBMmean,spPETBMall,trPETBM]=OtPET('ModelMean/MeanPEMB.mat','MeanPEMB');
globalMap(trPETHSmean, latForm, lonForm,'clercmap',0,'RGB',MatCM(55,16,'R'),'Projection','pcarree','shadow',maskpre,'climx',[0 4],'point',spPETHSall,'defaultsubplot',1,'TitleString','','ColorBarLabel','slop [% 10 /yr]')
PlotLonNew(trPETHS,1,[0 7],1.62,true)
globalMap(trPETBMmean, latForm, lonForm,'clercmap',0,'RGB',MatCM(55,16,'R'),'Projection','pcarree','shadow',maskpre,'climx',[0 4],'point',spPETBMall,'defaultsubplot',1,'TitleString','','ColorBarLabel','slop [% 10 /yr]')
PlotLonNew(trPETBM,10,[0 10],2.28,true)


% Supplementary results for each SSP scenario
ssp={'ssp126','ssp245','ssp370','ssp585'};
[trFa,p1Fr]=FraSSP4(ssp,SMrootModelName,DateStr,SSI);
for i=1:4
    globalMap(tr(:,:,i), latForm, lonForm,'clercmap',0,'RGB',MatCM(98,8),'Projection','eckert3','shadow',maskpre,'climx',[-1 1],'point',pmkSM(:,:,i),'defaultsubplot',0,'TitleString','','ColorBarLabel','[%]')
    globalMap(trFa(:,:,i)*86, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,8,'R'),'clim',[-1 1],'Projection','eckert3','point',p1Fr(:,:,i)<0.05,'shadow',maskpre,'defaultsubplot',0,'TitleString','','ColorBarLabel','[Counts/ 120 yr]')
end

% Attribution of annual future increases in flash-drought frequency
% 1. Trend in flash-drought occurrence
k=1;
for i=1:length(SMrootModelName)
    disp(SMrootModelName{i})
    FDroot=load(['FlashDroughtEvent/' SMrootModelName{i}]);
    [Fra,Dur,Int]=GetCha(FDroot.FD,DateStr,SSI.SSI_obs{2},SSI.SSI_gcm);
    if any(ismember(fieldnames(Fra),'ssp585'))
        FraSSP(:,:,:,k)=Fra.ssp585;
        DurSSP(:,:,:,k)=Dur.ssp585;
        IntSSP(:,:,:,k)=Int.ssp585;
        k=k+1;
        % FraYr=squeeze(nansum(Fra.ssp585,[1 2]));
        % DurYr=squeeze(nanmean(Dur.ssp585,[1 2]));
        % IntYr=squeeze(nanmean(Int.ssp585,[1 2]));
    end
end
FraSSP(:,:,:,end+1)=nanmean(FraSSP,4);
PlotLonNew(squeeze(mean(DurSSP,3)),1,[0 20],6,false)

DurSSP(:,:,:,end+1)=nanmean(DurSSP,4);
IntSSP(:,:,:,end+1)=nanmean(IntSSP,4);
FraSSP=fillmissing(FraSSP,'linear',3);% Fill missing values
DurSSP=fillmissing(DurSSP,'linear',3);% Fill missing values
IntSSP=fillmissing(IntSSP,'linear',3);% Fill missing values
for i=1:9
    [tr1(:,:,i),p1]=trend(FraSSP(:,:,:,i));
    [tr2(:,:,i),p2]=trend(DurSSP(:,:,:,i));
    [tr3(:,:,i),p3]=trend(IntSSP(:,:,:,i)*-1);
    [~, ~, ~, adj_p1(:,:,i)] = fdr_bh(p1, 0.01, 'pdep', 'yes');% FDR correction
    [~, ~, ~, adj_p2(:,:,i)] = fdr_bh(p2, 0.01, 'pdep', 'yes');
    [~, ~, ~, adj_p3(:,:,i)] = fdr_bh(p3, 0.01, 'pdep', 'yes');
end
save CharacteristicTrends tr1  tr2 tr3
% Plot ensemble mean for Supplementary Fig. S18
globalMap(tr1(:,:,end)*86, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,8,'R'),'clim',[-1 1],'Projection','eckert3','point',adj_p1(:,:,end)<0.05,'shadow',maskpre,'defaultsubplot',0,'TitleString','Frequency Trend','ColorBarLabel','[Counts/ 120 yr]')
GeoPlotPie(tr1(:,:,end)*86,adj_p1(:,:,end))
% PlotLonNew(tr1*86,1,[-1 1],0,false)
globalMap(tr2(:,:,end), latForm, lonForm,'clercmap',0,'RGB',MatCM(92,8,'R'),'clim',[-0.08 0.08],'Projection','eckert3','point',adj_p2(:,:,end)<0.05,'shadow',maskpre,'defaultsubplot',0,'TitleString','Duration Trend','ColorBarLabel','[Day/yr]')
GeoPlotPie(tr2(:,:,end),adj_p2(:,:,end))
% PlotLonNew(tr2,1,[-0.08 0.08],0,false)
globalMap(tr3(:,:,end), latForm, lonForm,'clercmap',0,'RGB',MatCM(92,8,'R'),'clim',[-0.2 0.2],'Projection','eckert3','point',adj_p3(:,:,end)<0.05,'shadow',maskpre,'defaultsubplot',0,'TitleString','Intensity Trend','ColorBarLabel','[Counts/yr]')
GeoPlotPie(tr3(:,:,end),adj_p3(:,:,end))
% PlotLonNew(tr3,5,[-0.2 0.2],0,false)

% Geographical detector
Buffer=load('MeteForcing-Trend');
load CharacteristicTrends
Buffer=structfun(@(x) mean(x,3),Buffer,'UniformOutput',false);
vname={'Buffer','ET_{loss}','PET','VPD','PR_{deficit}'};
% Frequency
ymap1=tr1(:,:,end)*86;
ind=~isnan(ymap1+Buffer.tr+Buffer.trET+Buffer.trPET+Buffer.trVPD+Buffer.trPr);
ym1=[ymap1(ind) Buffer.tr(ind)*-1 Buffer.trET(ind) Buffer.trPET(ind) Buffer.trVPD(ind) Buffer.trPr(ind)];
[q1, p1] = geodetector_factor(ym1,999);
VBar(q1, vname, [1 158 147]/255);
xlim([0 0.3])
% Duration
ymap1=tr2(:,:,2);
ymap1(ymap1>0.05|ymap1<-0.05)=nan;
ind=~isnan(ymap1+Buffer.tr+Buffer.trET+Buffer.trPET+Buffer.trVPD+Buffer.trPr);
ym2=[ymap1(ind) Buffer.tr(ind)*-1 Buffer.trET(ind) Buffer.trPET(ind) Buffer.trVPD(ind) Buffer.trPr(ind)];
[q2, p2] = geodetector_factor(ym2,999);
VBar(q2, vname, [1 158 147]/255);
xlim([0 0.03])
% Intensity
ymap1=tr3(:,:,end);
ymap1(ymap1>5|ymap1<-5)=nan;
ind=~isnan(ymap1+Buffer.tr+Buffer.trET+Buffer.trPET+Buffer.trVPD+Buffer.trPr);
ym3=[ymap1(ind) Buffer.tr(ind)*-1 Buffer.trET(ind) Buffer.trPET(ind) Buffer.trVPD(ind) Buffer.trPr(ind)];
[q3, p3] = geodetector_factor(ym3,999);
VBar(q3, vname, [1 158 147]/255);
xlim([0 0.08])

% Information Flow-Based Causality Analysis

IntSSP(IntSSP>999|IntSSP<-999)=nan;
X12mat=nanmean(FraSSP,4);
X13mat=nanmean(DurSSP,4);
X14mat=nanmean(IntSSP,4);

Y1_PR=nanmean(gapPr,4);
Y2_VPD=nanmean(gapVPD,4);
Y3_PET=nanmean(gapPET,4);
Y4_ET=nanmean(gapET,4);
Y5_BF=nanmean(gapBF,4);

% Quantifies the source variable's annual contribution to the rate of change in the target's marginal entropy, not to the target value itself.
% A nat measures information on a natural-logarithm scale, analogous to a bit on a base-2 scale.
[IF1,P1]=CausalityMap(Y2_VPD,X12mat);
% globalMap(IF1, latForm, lonForm,'clercmap',0,'RGB',MatCM(19,10),'clim',[0 0.5],'Projection','pcarree','point',P1,'shadow',maskpre,'defaultsubplot',1,'TitleString','T_{1→2}: VPD→Fra','ColorBarLabel','[nats·yr^{-1}]')
globalMap(IF1, latForm, lonForm,'clercmap',0,'RGB',MatCM(19,10),'clim',[0 0.5],'Projection','pcarree','ShowIPCCname',0,'point',P1,'shadow',maskpre,'defaultsubplot',1,'TitleString','T_{1→2}: VPD→Fra','ColorBarLabel','[Nats·yr^{-1}]')
% Fig.4e
globalMapIPCC1(IF1, latForm, lonForm,'region','IPCC','Math','mean','RGB',MatCM(19,12),'Projection','eckert3','shadow',maskpre,'ShowIPCCname',1,'remeth',"nearest",'climx',[0 0.3],'defaultsubplot',0,'TitleString','','ColorBarLabel','[Nats·yr^{-1}]')
% Fraction of significant grid cells
SigVPD=sum(P1,'all')/sum(land,'all')
PlotPie([70 30], MatCM(19,2,'r'), [1])
% Fig.S20-21
[IF2,P2]=CausalityMap(Y3_PET,X12mat);
globalMap(IF2, latForm, lonForm,'clercmap',0,'RGB',MatCM(19,10),'clim',[0 0.5],'Projection','pcarree','point',P2,'shadow',maskpre,'defaultsubplot',1,'TitleString','T_{1→2}: PET→Fra','ColorBarLabel','[Nats·yr^{-1}]')
SigPET=sum(P2,'all')/sum(land,'all')

[IF3,P3]=CausalityMap(Y1_PR,X12mat);
globalMap(IF3, latForm, lonForm,'clercmap',0,'RGB',MatCM(19,10),'clim',[0 0.5],'Projection','pcarree','point',P3,'shadow',maskpre,'defaultsubplot',1,'TitleString','T_{1→2}: PR→Fra','ColorBarLabel','[Nats·yr^{-1}]')
SigPR=sum(P3,'all')/sum(land,'all')

[IF4,P4]=CausalityMap(Y4_ET,X12mat);
globalMap(IF4, latForm, lonForm,'clercmap',0,'RGB',MatCM(19,10),'clim',[0 0.5],'Projection','pcarree','point',P4,'shadow',maskpre,'defaultsubplot',1,'TitleString','T_{1→2}: ET→Fra','ColorBarLabel','[Nats·yr^{-1}]')
SigET=sum(P4,'all')/sum(land,'all')


[IF5,P5]=CausalityMap(Y5_BF,X12mat);
globalMap(IF5, latForm, lonForm,'clercmap',0,'RGB',MatCM(19,10),'clim',[0 0.5],'Projection','pcarree','point',P5,'shadow',maskpre,'defaultsubplot',1,'TitleString','T_{1→2}: Buffer→Fra','ColorBarLabel','[Nats·yr^{-1}]')
SigBF=sum(P5,'all')/sum(land,'all')

X12matvct=squeeze(nanmean(X12mat,[1 2]));
X13matvct=squeeze(nanmean(X13mat,[1 2]));
X14matvct=squeeze(nanmean(X14mat,[1 2]));

Y2_VPDvct=squeeze(nanmean(Y2_VPD,[1 2]));
Y3_PETvct=squeeze(nanmean(Y3_PET,[1 2]));
Y1_PRvct=squeeze(nanmean(Y1_PR,[1 2]));
Y4_ETvct=squeeze(nanmean(Y4_ET,[1 2]));
Y5_BFvct=squeeze(nanmean(Y5_BF,[1 2]));

np = 1; alpha = 0.05;

[TVPD,e95_12,alp_VPD]=causality_Vct(Y2_VPDvct,X12matvct,np);%VPD->Fra
[TPET,e95_12,alp_PET]=causality_Vct(Y3_PETvct,X12matvct,np);%VPD->Fra
[TPR,e95_12,alp_PR]=causality_Vct(Y1_PRvct,X12matvct,np);%VPD->Fra
[TET,e95_12,alp_ET]=causality_Vct(Y4_ETvct,X12matvct,np);%VPD->Fra
[TBF,e95_12,alp_BF]=causality_Vct(Y5_BFvct,X12matvct,np);%VPD->Fra

IFmat=[TVPD TPET TPR TET TBF];

MultiX=[Y2_VPDvct Y3_PETvct Y1_PRvct Y4_ETvct Y5_BFvct];
Yvct=X12matvct;
save Causal-Input MultiX Yvct
S=load('Causal-Input.mat','MultiX','Yvct');
addpath MyFun\LKIF
variableNames=["VPD","PET","PR","ET","Buffer","Flash drought"];
result=lkif_analyze_multiX(S.MultiX(:,[1 2 3 5]),S.Yvct, ...
    'MaxLag',1, ...          % Information flow from the preceding time step to the current step
    'Np',1, ...              % A value of 1 is typical for regular time series
    'Dt',1, ...              % Set to the actual sampling interval, for example 1 for daily data
    'Alpha',0.05, ...        % 5% significance level
    'Standardize',true, ...  % Recommended for numerical stability across variables with different units
    'FDR',false, ...          % Benjamini-Hochberg correction for multiple edge tests
    'Plot',true, ...         % Plot the significant conditional-causality graph
    'VariableNames',variableNames([1 2 3 5 6]));
result=lkif_analyze_multiX(S.MultiX(:,:),S.Yvct, ...
    'MaxLag',1, ...          % Information flow from the preceding time step to the current step
    'Np',1, ...              % A value of 1 is typical for regular time series
    'Dt',1, ...              % Set to the actual sampling interval, for example 1 for daily data
    'Alpha',0.05, ...        % 5% significance level
    'Standardize',false, ...  % Standardization can improve numerical stability across different units
    'FDR',true, ...          % Benjamini-Hochberg correction for multiple edge tests
    'Plot',true, ...         % Plot the significant conditional-causality graph
    'VariableNames',variableNames);

% Principal outputs:
result.significantToY       % Xi -> Y links that remain significant after FDR correction
result.toY                  % IF, nIF, p, and q for all Xi -> Y links
result.fromY                % All Y -> Xi links, used to assess potential reverse effects
result.significantEdges     % All significant directed edges in the system


% corr(ym)
% C = Contribution(ym, 'std');
% globalMap(ymap, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,16,'R'),'Projection','eckert3','shadow',maskpre,'point',spPETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
% globalMap(Buffer.tr, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,16,'R'),'Projection','eckert3','shadow',maskpre,'point',spPETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
% globalMap(Buffer.trET, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,16,'R'),'Projection','eckert3','shadow',maskpre,'point',spPETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
% globalMap(Buffer.trPET, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,16,'R'),'Projection','eckert3','shadow',maskpre,'point',spPETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
% globalMap(Buffer.trVPD, latForm, lonForm,'clercmap',0,'RGB',MatCM(92,16,'R'),'Projection','eckert3','shadow',maskpre,'point',spPETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')

% Supplementary Fig. S18. Comparison among three historical datasets
GDFC=load("HistReanalysis/Observed_GDFC.mat",'PRpct5d','TApct5d','ETpct5dr','SMrootpct5d');
ERA5=load("HistReanalysis/Observed_ERA5.mat",'PRpct5d','TApct5d','ETpct5d','SMrootpct5d');
GLDS=load("HistReanalysis/Observed_GLDAS.mat",'PRpct5d','TApct5d','ETpct5d','SMrootpct5d');
catPr=cat(4,GDFC.PRpct5d,ERA5.PRpct5d,GLDS.PRpct5d);
catPr=squeeze(mean(catPr,3));
catTA=cat(4,GDFC.TApct5d,ERA5.TApct5d,GLDS.TApct5d);
catTA=squeeze(mean(catTA,3));
catET=cat(4,GDFC.ETpct5dr,ERA5.ETpct5d,GLDS.ETpct5d);
catET=squeeze(mean(catET,3));
catSM=cat(4,GDFC.SMrootpct5d,ERA5.SMrootpct5d,GLDS.SMrootpct5d);
catSM=squeeze(mean(catSM,3));
% 1. Precipitation
globalMap(mean(catPr,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(56,14),'clim',[0 35],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','[mm]')
PlotLonNew(catPr,1,[0 35],8.03,false)
catPr(:,:,end+1)=mean(catPr,3);
catPr2d=reshape(catPr,[],4);
catPr2d(catPr2d>70)=nan;
catPr2d=catPr2d(~isnan(sum(catPr2d,2)),:);
R2Pr=corr(catPr2d,'Type','Spearman')
ScatterPlot(catPr2d(:,2), catPr2d(:,4), MatCM(56,14));
% xticks([0:10:70])
% yticks([0:10:70])
% xlim([0 70])
% ylim([0 70])
xlabel('Ensemble Mean [mm]')
ylabel('ERA5-Land [mm]')
% 2. Air temperature
globalMap(mean(catTA,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(98,12,'r'),'clim',[-30 30],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','[℃]')
PlotLonNew(catTA,1,[-30 30],7.97,false)
catTA(:,:,end+1)=mean(catTA,3);
catTA2d=reshape(catTA,[],4);
catTA2d(catTA2d>70)=nan;
catTA2d=catTA2d(~isnan(sum(catTA2d,2)),:);
R2Pr=corr(catTA2d,'Type','Spearman')
ScatterPlot(catTA2d(:,2), catTA2d(:,4), MatCM(98,255,'r'));
% xticks([-30:10:30])
% yticks([-30:10:30])
% xlim([-30 30])
% ylim([-30 30])
xlabel('Ensemble Mean [℃]')
ylabel('ERA5-Land [℃]')

% 3. Evaporation
globalMap(mean(catET,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(20,16),'clim',[0 20],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','[mm]')
PlotLonNew(catET,1,[0 20],6.25,false)
catTA(:,:,end+1)=mean(catTA,3);
catET2d=reshape(catTA,[],4);
% catET2d(catET2d>70)=nan;
catET2d=catET2d(~isnan(sum(catET2d,2)),:);
R2Pr=corr(catET2d,'Type','Spearman')
ScatterPlot(catET2d(:,2), catET2d(:,4), MatCM(20,255));
xticks([0:5:20])
yticks([0:5:20])
xlim([0 20])
ylim([0 20])
xlabel('Ensemble Mean [mm]')
ylabel('ERA5-Land [mm]')
% 4.0-100cm SM
globalMap(mean(catSM,3), latForm, lonForm,'clercmap',0,'RGB',MatCM(80,10,'R'),'clim',[0 0.5],'Projection','pcarree','shadow',maskpre,'defaultsubplot',1,'TitleString','','ColorBarLabel','[m^{3}/m^{3}]')
PlotLonNew(catSM,1,[0 0.5],0.26,false)
catSM(:,:,end+1)=mean(catSM,3);
catSM2d=reshape(catSM,[],4);
% catET2d(catET2d>70)=nan;
catSM2d=catSM2d(~isnan(sum(catSM2d,2)),:);
R2Pr=corr(catSM2d,'Type','Spearman')
ScatterPlot(catSM2d(:,2), catSM2d(:,4), MatCM(80,10,'R'));
xticks([0:0.1:0.5])
yticks([0:0.1:0.5])
xlim([0 0.5])
ylim([0 0.5])
xlabel('Ensemble Mean [m^{3}/m^{3}]')
ylabel('ERA5-Land [m^{3}/m^{3}]')


