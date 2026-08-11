
addpath('J:\A_Hard_disk\IDM下载地址\SOFTX-D-21-00039-master\SOFTX-D-21-00039-master')
% addpath  J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\A1_FDidentify
SMpct5d_GDFCX=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data/OriginalData/Z_Resample/Observed_GDFC.mat","SMrootpct5d","SMsurfpct5d","maskPRE","date5d");
SMpct5d_GLDAS=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data/OriginalData/Z_Resample/Observed_GLDAS.mat","SMrootpct5d","SMsurfpct5d","maskPRE");
SMpct5d_ERA5X=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data/OriginalData/Z_Resample/Observed_ERA5.mat","SMrootpct5d","maskPRE",'SMsurfpct5d','SMsurf1pct5d','SMsurf2pct5d');
SMpct5d_MeanX=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data/OriginalData/Z_Resample/Observed_Median.mat","SMrootpct5d","SMsurfpct5d");

% GCM_QM_CanESM=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/GCM_QM_CanESM.mat");
% % GCM_QM_MIROC6=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/GCM_QM_MIROC6.mat");
% GCM_QM_IPSLCM=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/GCM_QM_IPSL.mat");
% GCM_QM_IPSLCM.GCM=GCM_QM_IPSLCM;
load('坐标信息.mat')
% obse
SSI_obs{1}=SMpct5d_GDFCX.SMsurfpct5d;
SSI_obs{2}=SMpct5d_GDFCX.SMrootpct5d;
SSI_obs{3}=SMpct5d_GLDAS.SMsurfpct5d;
SSI_obs{4}=SMpct5d_GLDAS.SMrootpct5d;
SSI_obs{5}=SMpct5d_ERA5X.SMsurfpct5d;
SSI_obs{6}=SMpct5d_ERA5X.SMrootpct5d;
SSI_obs{7}=SMpct5d_MeanX.SMsurfpct5d;
SSI_obs{8}=SMpct5d_MeanX.SMrootpct5d;
% 1.干旱指数
% Obs
SSI_obs=cellfun(@SDImode,SSI_obs,'UniformOutput',false);
% GCM
SSP={'126','245','370','585'};



for i=1:4
    disp(i)
    mod1=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample\校正/CanESM5_SMpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample\校正/IPSLCM6_SMpct5d_SSP' SSP{i} '.mat']);
    SSI_modhis=cellfun(@SDImode,{mod1.His mod2.His},'UniformOutput',false);%1.历史
    SSI_modpro=cellfun(@SDImode,{mod1 mod2 },'UniformOutput',false);% 2.未来【基于历史】
    SSI_mod={SSI_modhis{[1 2]} SSI_modpro{[1 2]}};%前两个是历史 后两个是未来
    SSI_gcm{i}=SSI_mod;
end

clear SSI_mod SSI_modhis SSI_modpro
save 指数SSI SSI_obs SSI_gcm
% 2.干旱事件
[FDsCell_obs,FDsNum_obs,FDsD_obs,FDhc_obs,down_obs]=cellfun(@FDenvent,SSI_obs,'UniformOutput',false);
for i=1:4
    disp(SSP{i})
    [FDsCell_gcm{i},FDsNum_gcm{i},FDsD_gcm{i},FDhc_gcm{i},down_gcm{i}]=cellfun(@FDenventEns,SSI_gcm{i},'UniformOutput',false);
end
save 干旱事件 FDsCell_obs FDsNum_obs FDsD_obs FDhc_obs FDsCell_gcm FDsNum_gcm FDsD_gcm FDhc_gcm down_obs down_gcm
% 格点
load('J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/LonLat.mat')
load('格林兰和撒哈拉掩膜.mat')
maskPREGDFC=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData/Z_Resample/Observed_GDFC.mat",'maskPRE','nanind');
maskPREERA5=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_ERA5.mat",'maskPRE');
maskPREGLDAS=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_GLDAS.mat",'maskPRE');
nanind=maskPREGDFC.nanind;
maskPREGDFC=maskPREGDFC.maskPRE;
maskPREERA5=maskPREERA5.maskPRE;
maskPREGLDAS=maskPREGLDAS.maskPRE;
maskmean=maskPREGDFC&maskPREERA5&maskPREGLDAS;
maskmeanF=(maskPREGDFC|maskPREERA5|maskPREGLDAS)&~maskmean;%不确定性的格点
nanindall=nanind|shl_inpolygon|gll_inpolygon|maskmean;%删除的格点（海洋+撒哈拉+格林兰岛+日均降水<0.5mm）
% nanindall=nanind|shl_inpolygon|gll_inpolygon|maskmean;%删除的格点（海洋+撒哈拉+格林兰岛+日均降水<0.5mm）
maskpre=shl_inpolygon|gll_inpolygon|maskmean;
save 掩膜 nanindall maskpre
% RGB1 = flip(cbrewer2('seq', 'brbg', 12, 'PCHIP'));
RGB1 = flip(cbrewer2('div', 'PIYG', 12, 'PCHIP'));
RGBredblu=flip(cbrewer2('div', 'rdylbu', 12, 'PCHIP'));
RGBpinkgreen=flip(cbrewer2('div', 'PIYG', 10, 'PCHIP'));
titx={'Historical Flash Drought Events (GDFC surf SM)','Historical Flash Drought Events (GDFC root SM)','Historical Flash Drought Events (GLDAS surf SM)','Historical Flash Drought Events (GLDAS root SM)','Historical Flash Drought Events (ERA5 surf SM)','Historical Flash Drought Events (ERA5 root SM)','Historical Flash Drought Events (Mean surf SM)','Historical Flash Drought Events (Mean root SM)'};
titxdatset={'GDFC','GLDAS','ERA5','Ens.'};

%%支持信息 Fig.S 不同数据集土壤湿度数据识别的干旱事件频率：不同数据集 + 深度 + 差异
for i=1:8
    FDsNum_obs{i}(nanindall)=nan;
    globalMap(FDsNum_obs{i}, latForm, lonForm,'RGB',RGBredblu,'climx',[0 30],'Projection','eckert3','shadow',maskpre,'TitleString',titx{i},'ColorBarLabel','Mean duration [pentads·yr^{-1}]')
end
for i=1:4 %surf和root之差
    FDsNum_obs{2*i-1}(nanindall)=nan;
    FDsNum_obs{2*i}(nanindall)=nan;
    globalMap(FDsNum_obs{2*i-1}-FDsNum_obs{2*i}, latForm, lonForm,'RGB',RGBpinkgreen,'climx',[-25 25],'Projection','eckert3','shadow',maskpre,'TitleString',titxdatset{i},'ColorBarLabel','Mean duration [pentads·yr^{-1}]')
end

%Fig.1c 年平均骤旱历时-根区【正文】
FDsNum=mean(cat(3,FDsNum_obs{[8]}),3);
FDhc=mean(cat(3,FDhc_obs{[8]}),3);

FDsD=mean(cat(3,FDsD_obs{[8]}),3);
figtitle='Historical Flash Drought Events (Mean root SM)';%年平均骤旱历时-根区
% globalMapIPCC1(FDsNum/65.*FDsD, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 16, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[0.5 2.5],'TitleString','','ColorBarLabel','Mean duration [pentads·yr^{-1}]')
globalMapIPCC1(FDsNum, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 16, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[0 30],'TitleString','','ColorBarLabel','Number of Flash Droughts [Counts·65yr^{-1}]')
FDhc(nanindall)=nan;
globalMapIPCC1(FDhc, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 15, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[0 200],'TitleString','','ColorBarLabel','Number of Flash Droughts [Counts·65yr^{-1}]')
%按kam的改，两者相同[支持信息 FIG.S2]
globalMapIPCC1(FDhc./FDsNum, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 10, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[4 9],'TitleString','','ColorBarLabel','Mean duration [pentads/event]')
[~,fqtj,IPCCRe_meanDuration]=globalMapIPCC1(FDsD, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 10, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[4 9],'TitleString','','ColorBarLabel','Mean duration [pentads/event]')

%拆解
globalMapIPCC1(FDsNum/65, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 10, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[0 0.5],'TitleString','','ColorBarLabel','Frequency of Flash Droughts [Counts·yr^{-1}]')
globalMapIPCC1(FDsNum/65.*FDsD, latForm, lonForm,'region','IPCC','Math','mean','RGB',flip(cbrewer2('div', 'brbg', 16, 'PCHIP')),'Projection','pcarree','shadow',maskpre,'remeth',"nearest",'climx',[0.5 2.5],'TitleString','','ColorBarLabel','Mean duration [pentads·yr^{-1}]')

%表层【支持信息】
FDsNum=mean(cat(3,FDsNum_obs{[7]}),3);
FDsD=mean(cat(3,FDsD_obs{[7]}),3);
globalMapIPCC1(FDsNum/65.*FDsD, latForm, lonForm,'region','IPCC','Math','mean','RGB',RGB1,'Projection','pcarree','shadow',maskpre,'climx',[0.5 2.5],'TitleString','Historical Flash Drought Events (Mean surf SM)','ColorBarLabel','Mean duration [pentads·yr^{-1}]')

for i=8
    %一元色带
    globalMapIPCC1(FDsNum_obs{i}/65.*FDsD_obs{i}, latForm, lonForm,'region','IPCC','RGB',RGB1,'Projection','robinson','shadow',maskpre,'climx',[0.5 2.5],'TitleString','Historical Flash Drought Events (Mean root SM)','ColorBarLabel','Mean duration [pentads·yr^{-1}]')
    %二元映射
    globalMap2IPCC(FDsNum_obs{i}/65,FDsD_obs{i}, latForm, lonForm,'region','IPCC','RGB',RGB1,'Projection','pcarree','shadow',maskpre,'climx',[0 3],'TitleString','Historical Flash Drought Events (Mean root SM)','ColorBarLabel','Mean duration [pentads·yr^{-1}]')
end

%主导型
PTGDFC=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_GLDAS.mat","PRpct5d","TApct5d",'ETpct5d');
PTGLDAS=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_GDFC.mat","PRpct5d","TApct5d",'ETpct5d');
PTERA5=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_ERA5.mat","PRpct5d","TApct5d",'ETpct5d');
PTMean=load("J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/Observed_Median.mat",'PRpct5d','TApct5d','ETpct5d');
% 1.SPI
% obse
SPI_obs{1}=PTGDFC.PRpct5d;
SPI_obs{2}=PTGLDAS.PRpct5d;
SPI_obs{3}=PTERA5.PRpct5d;
SPI_obs{4}=PTMean.PRpct5d;
SPI_obs=cellfun(@SDImode,SPI_obs,'UniformOutput',false);
%GCM
SSP={'126','245','370','585'};
for i=1:4
    disp(i)
    mod1=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/CanESM5_PRpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/IPSLCM6_PRpct5d_SSP' SSP{i} '.mat']);
    SPI_modhis=cellfun(@SDImode,{mod1.His mod2.His},'UniformOutput',false);%1.历史
    SPI_modpro=cellfun(@SDImode,{mod1 mod2 },'UniformOutput',false);% 2.未来【基于历史】
    SPI_mod={SPI_modhis{[1 2]} SPI_modpro{[1 2]}};%前两个是历史 后两个是未来
    SPI_gcm{i}=SPI_mod;
end
clear SPI_mod SPI_modhis SPI_modpro
save 指数SPI SPI_obs SPI_gcm
% 2.STI
% obse
STI_obs{1}=PTGDFC.TApct5d;
STI_obs{2}=PTGLDAS.TApct5d;
STI_obs{3}=PTERA5.TApct5d;
STI_obs{4}=PTMean.TApct5d;
STI_obs=cellfun(@SDImode,STI_obs,'UniformOutput',false);
%GCM
for i=1:4
    disp(i)
    mod1=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/CanESM5_TApct5d_SSP' SSP{i} '.mat']);
    mod2=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/IPSLCM6_TApct5d_SSP' SSP{i} '.mat']);
    STI_modhis=cellfun(@SDImode,{mod1.His mod2.His},'UniformOutput',false);%1.历史
    STI_modpro=cellfun(@SDImode,{mod1 mod2 },'UniformOutput',false);% 2.未来【基于历史】
    STI_mod={STI_modhis{[1 2]} STI_modpro{[1 2]}};%前两个是历史 后两个是未来
    STI_gcm{i}=STI_mod;
end
clear STI_mod STI_modhis STI_modpro
save 指数STI STI_obs STI_gcm

% 3.SEI
% obse
SEI_obs{1}=PTGDFC.ETpct5d;
SEI_obs{2}=PTGLDAS.ETpct5d*24;
SEI_obs{3}=PTERA5.ETpct5d;
SEI_obs{4}=PTMean.ETpct5d;
SEI_obs=cellfun(@SDImode,SEI_obs,'UniformOutput',false);
%GCM
for i=1:4
    disp(i)
    mod1=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/CanESM5_ETpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/IPSLCM6_ETpct5d_SSP' SSP{i} '.mat']);
    SEI_modhis=cellfun(@SDImode,{mod1.His mod2.His},'UniformOutput',false);%1.历史
    SEI_modpro=cellfun(@SDImode,{mod1 mod2 },'UniformOutput',false);% 2.未来【基于历史】
    SEI_mod={SEI_modhis{[1 2]} SEI_modpro{[1 2]}};%前两个是历史 后两个是未来
    SEI_gcm{i}=SEI_mod;
end
clear SEI_mod SEI_modhis SEI_modpro mod1 mod2
save 指数SEI SEI_obs SEI_gcm


%% 三个数据集的降水量和气温对比
cellfun(@(dataset,c,clim) datasetVs(dataset,c,clim),{SPI_obs},{NclCM(244)},{[0 35]},'UniformOutput',false);
cellfun(@(dataset,c,clim) datasetVs(dataset,c,clim),{STI_obs},{MatCM(106)},{[-30 30]},'UniformOutput',false);
cellfun(@(dataset,c,clim) datasetVs(dataset,c,clim),{SEI_obs},{MatCM(19)},{[0 20]},'UniformOutput',false);
cellfun(@(dataset,c,clim) datasetVs(dataset,c,clim),{SSI_obs([2 4 6 8])},{MatCM(10)},{[0.2 0.6]},'UniformOutput',false);


see3d(SEI_obs{2})



%%判断主导型[不同数据集根区土壤水]

datehis=get_year_month_day(1950,2014,'noleap');
datehis5d=datehis(5:5:end,:);
datepro=get_year_month_day(2015,2100,'noleap');
datepro5d=datepro(5:5:end,:);
%obs
norminv(0.75)
PT0=0.45;
%根区土壤水
ET_obs{1}=PTGDFC.ETpct5d;
ET_obs{2}=PTGLDAS.ETpct5d;
ET_obs{3}=PTERA5.ETpct5d;
ET_obs{4}=PTMean.ETpct5d;

[CAT_obs, deta_obs, NumYr_obs,P_obs,dSPI_obs,dSTI_obs,dSSI_obs,downx_obs,NumMon_obs] = cellfun(@(fd,down, spi, sti,sei,ssi,pt, nanind, dateh) ...
    PTanom(fd, down,spi, sti, sei,ssi,pt, nanind, dateh), ...
    FDsCell_obs([2 4 6 8]), down_obs([2 4 6 8]),SPI_obs, STI_obs,SEI_obs,SSI_obs([2 4 6 8]),repmat({PT0}, 1, 4), repmat({nanindall}, 1, 4), repmat({datehis5d}, 1, 4), ...
    'UniformOutput', false);

see3d(CAT_obs{4}(:,:,:,2))%平均发病速度
see3d(ddownx{1, 4})
%表层土壤水
[CAT_obssurf, deta_obssurf, NumYr_obssurf,P_obssurf] = cellfun(@(fd, down,spi, sti,sei,ssi, pt, nanind, dateh) ...
    PTanom(fd, down,spi, sti,sei,ssi,pt, nanind, dateh), ...
    FDsCell_obs([1 3 5 7]), down_obs([1 3 5 7]),SPI_obs, STI_obs, SEI_obs,SSI_obs([1 3 5 7]),repmat({PT0}, 1, 4), repmat({nanindall}, 1, 4), repmat({datehis5d}, 1, 4), ...
    'UniformOutput', false);

%GCM
for i=1:4
    disp(i)
    [CAT_gcm{i}, deta_gcm{i}, NumYr_gcm{i},P_gcm{i},dSPI_gcm{i},dSTI_gcm{i},dSSI_gcm{i},downx_gcm{i},NumMon_gcm{i}] = cellfun(@(fd, down,spi, sti, sei,ssi,pt, nanind, dateh) ...
    PTanomEns(fd, down,spi, sti,sei,ssi, pt, nanind, dateh), ...
    FDsCell_gcm{i}, down_gcm{i},SPI_gcm{i}, STI_gcm{i},  SEI_gcm{i},SSI_gcm{i},repmat({PT0}, 1, 4), repmat({nanindall}, 1, 4), {datehis5d datehis5d datepro5d datepro5d}, ...
    'UniformOutput', false);
end

%Fig.3b
size(CAT_gcm{4}{1})
CAT_gcm{4}{1}(CAT_gcm{4}{1}==0)=nan;
CAT_gcm{4}{2}(CAT_gcm{4}{2}==0)=nan;
CAT_gcm{4}{3}(CAT_gcm{4}{3}==0)=nan;
CAT_gcm{4}{4}(CAT_gcm{4}{4}==0)=nan;

CAT585=squeeze(sum(cat(4,cat(6,CAT_gcm{4}{1},CAT_gcm{4}{2}),cat(6,CAT_gcm{4}{3},CAT_gcm{4}{4})),[1 6],'omitnan'));%SSP585对模型和集合求众数
size(CAT585)
% 分三个不同阶段

gapy=[1995,2070];
yr=1950:2100;
gapy1=find(yr==gapy(1)==1);
gapy2=find(yr==gapy(2)==1);

CAT585i1=squeeze(nansum(CAT585(:,:,1:gapy1,:),3));%1950-200
CAT585i2=squeeze(nansum(CAT585(:,:,gapy1+1:gapy2,:),3));%1950-200
CAT585i3=squeeze(nansum(CAT585(:,:,gapy2+1:151,:),3));%1950-200
[stage_type_ratios, flow_percentages]=plotSankeyFlashDrought(CAT585i1,CAT585i2,CAT585i3,colors)

sum(flow_percentages{2},1)

% Fig.2e【环图】
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
plotdroughtMulti(dg, dgx(:,[3 4 2 1]),{'c'})%多维[从内-外：降水，抵消，复合，热浪]
plotdroughtMultioroginal(dg, dgx(:,[3 4 2 1]),{'c'})%多维[从内-外：降水，抵消，复合，热浪]




% Fig3.暴露面积+发病速度
A = cdtarea(Lat,Lon,'km2');
A_land=mask3(A,~island(Lat,Lon));
totalArea=nansum(A_land,'all');%全球总陆地面积
[~,Are_obs,Arec_obs,pa_obs,V_obs]= cellfun(@(down,nanind,A,A_land) expose(down,nanind,A,A_land),downx_obs, repmat({nanindall}, 1, 4),repmat({A}, 1, 4),repmat({A_land}, 1, 4),'UniformOutput', false);
for i=1:4
    disp(SSP{i})
    [~,Are_gcm{i},Arec_gcm{i},pa_gcm{i},V_gcm{i}]= cellfun(@(down,nanind,A,A_land) expose(down,nanind,A,A_land),downx_gcm{i}, repmat({nanindall}, 1, 4),repmat({A}, 1, 4),repmat({A_land}, 1, 4),'UniformOutput', false);
end
%一.分开绘图
%1.暴露面积
mvwin=50;
k=1;
for i=[1 2 3 4]
    figure(i)
    l1=i;
    for s=1:4
        ENScatEns1=cat(1,Are_gcm{s}{1},Are_gcm{s}{3});%两个大模型
        ENScatEns2=cat(1,Are_gcm{s}{2},Are_gcm{s}{4});
        ENScatEns=cat(2,ENScatEns1,ENScatEns2);
        ENS1modEns=squeeze(ENScatEns);%151年 4种类型 5个集合*n个大模型
        % GCMs历史+未来
        [~,h] = ensemble2bnd(hisp,movmean(double(squeeze(ENS1modEns(:,:,l1))),mvwin), 'dims', 'xey', 'plot', 'boundedline', 'cent', 'median', 'prc', [0:2:48 52:2:100], 'tlim', [0.1 0.9],'cmap',RGB16(k,:));%[255 13 65]/255
        k=k+1;
        hold on
        % 观测
        plot(hisv,movmean(Are_obs{1}(:,l1),mvwin),'LineWidth',1.5,'Color',[221 52 151]/255)
        plot(hisv,movmean(Are_obs{2}(:,l1),mvwin),'LineWidth',1.5,'Color',[28 66 224]/255)
        plot(hisv,movmean(Are_obs{3}(:,l1),mvwin),'LineWidth',1.5,'Color',[0 153 134]/255)
        plot(hisv,movmean(Are_obs{4}(:,l1),mvwin),'LineWidth',1.5,'Color','k')
        xline(2014,'--','Color','k','LineWidth',0.8,'Label','2014 ','LabelVerticalAlignment','top');
        grid on
        % grid minor
        % ylim([0 0.6])
        xlabel('Year')
        ylabel('exposed area [%]')
    end
    % legend({'CMIP6','GDFC','GLDAS','ERA5','fda','cfdsa','dfs'})
end
colormap(RGB16)

%Fig.3d发病速度

mvwin=50;
onesetspeed(V_gcm,mvwin,hisp,RGB16)
onesetspeed_org(V_gcm,mvwin,hisp,RGB16)
%二.阶段平均柱状图【1950-1995,1996-2070,2071-2100】
% Fig.3c 暴露面积
k=1;
textx={'Pre.deficit-Driven','Compound-Intensified','Heatwave-Driven'};
RGB12=[cbrewer2('seq', RBG4lei{3}, 4);cbrewer2('seq', RBG4lei{2}, 4);cbrewer2('seq', RBG4lei{1}, 4)];
for i=1
    for s=1:4
        ENScatEns1=cat(1,Are_gcm{s}{1},Are_gcm{s}{3});%两个大模型
        ENScatEns2=cat(1,Are_gcm{s}{2},Are_gcm{s}{4});
        ENScatEns=cat(2,ENScatEns1,ENScatEns2);
        % ENS1modEns=mean(ENScatEns,3);%151年 4种类型 5个集合*n个大模型
        ENS1modEns=squeeze(ENScatEns(:,:,i));%151年
        stag1=nanmean(ENS1modEns(1:46,:));%平均每年的影响面积 46 + 75 +30
        stag2=nanmean(ENS1modEns(47:121,:));
        stag3=nanmean(ENS1modEns(122:151,:));
        stag(:,:,s)=[stag1' stag2' stag3'];%10行3列
    end
    barexposedarea(stag,RGB12,textx,totalArea)
    % ylim([0 10*10^6])
    ylabel('Exposed Area [km^{2}]')
end

% Fig.3 发病速度
k=1;
textx={'Pre.Deficit-dominated','Heatwave + Pre.Deficit','Heatwave-dominated'};
RGB12=[cbrewer2('seq', RBG4lei{3}, 4);cbrewer2('seq', RBG4lei{2}, 4);cbrewer2('seq', RBG4lei{1}, 4)];

for i=1:4
    for s=1:4
        ENScatEns1=cat(1,V_gcm{s}{1},V_gcm{s}{3});%两个大模型
        ENScatEns2=cat(1,V_gcm{s}{2},V_gcm{s}{4});
        ENScatEns=cat(2,ENScatEns1,ENScatEns2);
        % ENS1modEns=mean(ENScatEns,3);%151年 4种类型 5个集合*n个大模型
        ENS1modEns=squeeze(ENScatEns(:,:,i));%151年
        stag1=nanmean(ENS1modEns(1:46,:));
        stag2=nanmean(ENS1modEns(47:121,:));
        stag3=nanmean(ENS1modEns(122:151,:));
        stag(:,:,s)=[stag1' stag2' stag3'];%10行3列
    end
    barexposedarea(stag,RGB12,textx)
    % ylim([0 10*10^6])
    ylabel('onset rate [|%|]')
end


% 干旱事件期间气温升高了一个标准差
% Fig.4b 降水+气温异常
% Fig.4c 土壤水+蒸散发
RGB5={'',cbrewer2('seq', 'blues', 4),cbrewer2('seq', 'orrd', 4),cbrewer2('seq', 'greens', 4),cbrewer2('seq', 'RDPU', 4)};
% sgmaPTSMET(deta_gcm,RGB4)
sgmaPTSMET(deta_gcm,RGB5)


% Fig.4d+e 🔺buffer：年气候态的未来变化
brbg=flip(cbrewer2('div', 'brbg', 16, 'PCHIP'));
spectral=flip(cbrewer2('div', 'spectral', 8, 'PCHIP'));
piyg=flip(cbrewer2('div', 'piyg', 16, 'PCHIP'));
prgn=flip(cbrewer2('div', 'prgn', 8, 'PCHIP'));
rdylbu=cbrewer2('div', 'rdylbu', 16, 'PCHIP');
rdgy=flip(cbrewer2('div', 'rdgy', 16, 'PCHIP'));
for i=1:4
    disp(i)
    %一.土壤水
    mod1=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/CanESM5_SMpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/IPSLCM6_SMpct5d_SSP' SSP{i} '.mat']);
    %1.历史65年
    SMhis=squeeze(mean((mod1.His+mod2.His)/2,1));
    SMclimHis=mean(SMhis,3);%气候态
    SM20th=prctile(SMhis,20,3);%干旱阈值
    % 2.未来每年
    SMPro=squeeze(mean((mod1.Pro+mod2.Pro)/2,1));
    SMPro65=reshape(SMPro,61,144,73,[]);
    SMProyrmean=squeeze(mean(SMPro65,3));
    gap=(SMProyrmean-SM20th)./SM20th*100*10;
    [tr(:,:,i),sp(:,:,i)]=trend(gap);
    pmkSM(:,:,i)=mann_kendall(gap,0.01);

    %二.蒸散发
    mod1=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/CanESM5_ETpct5d_SSP' SSP{i} '.mat']);
    mod2=load(['J:\A_Hard_disk\论文+开题\A3_全球骤旱驱动因子变化\A1_data\OriginalData\Z_Resample/校正/IPSLCM6_ETpct5d_SSP' SSP{i} '.mat']);
    %1.历史65年
    EThis=squeeze(mean((mod1.His+mod2.His)/2,1));
    ETclimHis=mean(EThis,3);%气候态
    % 2.未来每年
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
globalMap(trmean, latForm, lonForm,'clercmap',0,'RGB',rdylbu,'Projection','eckert3','shadow',maskpre,'climx',[-0.8 0.8],'point',spall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')
globalMap(trETmean, latForm, lonForm,'clercmap',0,'RGB',brbg,'climx',[-4 4],'Projection','eckert3','shadow',maskpre,'point',spETall,'defaultsubplot',0,'TitleString',['Corrected before ' num2str(i)],'ColorBarLabel','[%]')


[q_values, p_values] = geodetector_factor(mat2d, num_permutations)







% Fig. 蒸散发异常【正太分布均值+标准差】
figure
 hold on;     % 保持图形，以便后续添加数据
 ct={'',[50 136 189]/255,[197 27 125]/255,[50 50 5]/255};
 labt={'',['Precipitation Anomaly [' char(963) ']'],['Temperature Anomaly [' char(963) ']'],['ET Anomaly [' char(963) ']']};
for j=[4]
    if j==3
    yyaxis right; % 激活左 y 轴
    % set(gca,'YColor','r')
    end
    for i=1:4
         % pause(5)
        x=[deta_gcm{i}{1}{1}(:,1);deta_gcm{i}{3}{1}(:,1)];
        y=[deta_gcm{i}{1}{1}(:,j);deta_gcm{i}{3}{1}(:,j)];
        % scatter(x,y,'AlphaData',0.1,'SizeData',0.5,'CData',ct{j})
      sspet{i}=y;
        hold on
        polyplot(x,y,2,'cmap',RGB4{j}(i,:),'error','alpha','transparency', 0.2,'linewidth',1.8)
    end
   ylim([-4 4])
   ylabel(labt{j})
     hold on;     % 保持图形，以便后续添加数据
     % set(gca,'YColor','b')
     
end
% yyaxis left
set(gca,'YColor','k','TickDir','out')
polyplot(deta_obs{4}(:,1),deta_obs{4}(:,4),2,'--','Color','k','linewidth',1)
% polyplot(deta_obs{4}(:,1),deta_obs{4}(:,3),2,'Color','k','linewidth',1)
grid on
xline(2014,'--','Color','k','LineWidth',0.8,'Label','Projection   ','LabelVerticalAlignment','top');
for i=1:4
    histfit(sspet{i})
    hold on
    xlim([-5 5])
end
sspetplot(sspet)
view([90 90]);%旋转
xlim([-4 4])
% for i=1:4
%     scatter(deta_gcm{1, 4}(:,1),deta_gcm{1, 4}(:,4))
% end
for i=1:4
    dt=dSSI_gcm;
    size(dt{i}{3})
    sdcv1=cat(4,dt{i}{1},dt{i}{3});
    sdcv2=cat(4,dt{i}{2},dt{i}{4});
    sdcv=(sdcv1+sdcv2)./2;
    sdcv=squeeze(nanmean(sdcv,1));
    % 
    % sdcv=squeeze(sdcv(1,:,:,:));
    t=datenum(datetime(1950:2100,1,1));
    [sdcv,p]= trend(sdcv,t,'omitnan');
    % imagesc(sdcv)
    % colormap(cmocean('curl'))
    % colorbar
    % clim([-0.1 0.1])
    % globalMapIPCC1(sdcv, latForm, lonForm,'region','IPCC','RGB',cmocean('curl'),'Projection','eckert3','showline',0,'climx',[ -0.5 0.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')

    globalMap(sdcv*365*10, latForm, lonForm,'RGB',cmocean('curl'),'climx',[-0.5 0.5],'Projection','eckert3')
end

% ,'shadow',maskpre,titx{i},'TitleString','ColorBarLabel','Mean duration [pentads·yr^{-1}]'

save 主导型 CAT_obs CAT_obssurf deta_obs deta_obssurf P_obs P_obssurf CAT_gcm  deta_gcm P_gcm dSPI_obs dSTI_obs dSSI_obs dSPI_gcm dSTI_gcm dSSI_gcm NumYr_gcm downx_gcm downx_obs NumMon_obs NumMon_gcm

%Fig.2e 1.占比变化堆叠图
% RGB3=cbrewer2('qual', 'Set1', 4);%每行是一个RGB颜色
% RGB3=[0.85 0.37 0.05; 0.13 0.55 0.13; 0.89 0.10 0.11; 0.16 0.44 0.74];
RGB3=[215 48 31; 182 26 139;  41 118 184;33 140 33 ]/255;
% RGB3=[252 141 89; 247 104 161; 116 196 118;  107 174 214]/255;%较浅色
RBG4lei={'orrd','rdpu','blues','greens'};%四种类型的颜色；
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
% 支持信息FIG.S4
size(P_gcm{1}{4})
for i=1:4
    portatiion=[Phis;pijx(:,:,i)];
    portatiion=movmean(portatiion(1:5:end,:),5,1);
    % plot([portatiion])
    barstack(hisp(1:5:end), portatiion*100,RGB3,[lentext {''}])
   % xticks([1950:10:2100])
end
%% Fig.3a主导型变化的三个阶段一张图
stage(Phis,pijx,hisp,RGB16)

%% Fig.s5 各类型骤旱事件数量变化
runx(NumYr_gcm,RGB16,hisp)

%% Fig.S6 a-d 各类型骤旱事件数量变化[空间分布]：最后一个65年（2036-2100），年平均骤旱事件频率相对于历史时期（1950-2014）的变化率，%【Pfuture- Ppast/ Ppast *100%】
CAT_obshis=squeeze(nansum(CAT_obs{4},3));%CAT_obshis(CAT_obshis==0)=nan;%历史基准【1950-2014】
RGBincrs1 = cbrewer2('seq', 'orrd', 12, 'PCHIP');
RGBincrs2 = cbrewer2('seq', 'rdpu', 12, 'PCHIP');
RGBdecrs3 = flip(cbrewer2('seq', 'greens', 12, 'PCHIP'));
RGBdecrs4 = flip(cbrewer2('seq', 'blues', 12, 'PCHIP'));
RGBcel={RGBincrs1,RGBincrs2,RGBdecrs3,RGBdecrs4};
Tlim={[0 30],[0 30],[-30 0],[-30 0]};
TitleString={'Increased heatwave-driven','Increased compound-intensified','Reduced precipitation-deficit','Reduced cold/snow-induced'};
for s=1%:SSPn%126放在主图，即使是126也会增加（附图放585，增加得更多）
    % s=1
    CAT_his=CAT_gcm{s}{1}+CAT_gcm{s}{2};CAT_his=squeeze(mean(CAT_his,1));CAT_his=squeeze(sum(CAT_his,3));
    CAT_pro=CAT_gcm{s}{3}+CAT_gcm{s}{4};CAT_pro=squeeze(mean(CAT_pro,1));CAT_pro=squeeze(sum(CAT_pro(:,:,end-65+1:end,:),3));
  
    chnge=(CAT_pro-CAT_his);%./CAT_his*100;
    chnge(chnge==0)=nan;
    for i=1:4
    [~,~]=globalMapIPCC1(chnge(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',Tlim{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]');
    % [~,CountHist{i}]=globalMapIPCC1(CAT_his(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]');
    % [~,CountProj{i}]=globalMapIPCC1(CAT_pro(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'Projection','eckert3','shadow',maskpre,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]');
    end
    % pause(5)
    % close all
    %%如何表征不同排放情景？二元地图？图上加上阴影？
    % see3d(chnge)
end
CountHistHeatwave=CountHist{1};
CountHistCompound=CountHist{2};
CountProjHeatwave=CountProj{1};
CountProjCompound=CountProj{2};

PlotHistProj(CountHistHeatwave,CountHistCompound,CountProjHeatwave,CountProjCompound)

HeatwaveFlashDrought=fqtj{1};
CompoundFlashDrought=fqtj{2};


clear CountHist CountProj

%% 支持信息IPCC reference regions【Fig.S1】
globalMapIPCC1(chnge(:,:,i), latForm, lonForm,'region','IPCC','Math','mean','RGB',RGBcel{i},'climx',[9000 9999],'Projection','pcarree','shadow',maskpre,'defaultsubplot',0,'TitleString',TitleString{i},'ColorBarLabel','Change of Count [times·65yr^{-1}]')


size(CAT_obs{1, 4})

% Fig.2a-d占比变化分图
Fig2c={'oranges','reds','blues','greens'};%四种类型的颜色；
RGBFig2=[cbrewer2('seq', Fig2c{1}, 4);cbrewer2('seq', Fig2c{2}, 4);cbrewer2('seq', Fig2c{3}, 4);cbrewer2('seq', Fig2c{4}, 4)];

EnsLine(P_gcm,P_obs,hisp,hisv,RGBFig2) %50年滑动平均，抑制高频变化并突出多年的水文趋势


colormap(RGB16)
colorbar
colors = cbrewer2('qual', 'Paired', 8);
% colors = colors([8 6 2 4],:);
colors=[227 74 51;197 27 138;49 130 189;49 163 84]/255;
%四象限绘图并统计占比[支持信息]
PT0=0.45;
stats_SMroot_GDFC=quadrants1d(deta_obs{1}(:,2:3),PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GDFC','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMroot_GLDAS=quadrants1d(deta_obs{2}(:,2:3),PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GLDAS','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
% Fig.1d ERA5+【支持信息Fig.s3】
stats_SMroot_ERA5=quadrants1d(deta_obs{3}(:,2:3),0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);

stats_SMsurf_GDFC=quadrants1d(deta_obssurf{1}(:,2:3),PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GDFC','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMsurf_GLDAS=quadrants1d(deta_obssurf{2}(:,2:3),PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','GLDAS','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_SMsurf_ERA5=quadrants1d(deta_obssurf{3}(:,2:3),PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','ERA5','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);

% stats_SMroot_Mean=quadrants(deta_obs{4}(:,2:3),PT0,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation anomaly [' char(963) ']' ],'ylabel',['Temperature anomaly [' char(963) ']'] ,'FontSize',16);
stats_SMroot_Mean=quadrants1d(deta_obs{4}(:,2:3),0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation anomaly [' char(963) ']' ],'ylabel',['Temperature anomaly [' char(963) ']'] ,'FontSize',16);
stats_SMsurf_Mean=quadrants1d(deta_obssurf{4}(:,2:3),0.5,'QuadrantColors',[colors;0.85 0.85 0.85],'TitleString','','xlabel',['Precipitation anomaly [' char(963) ']' ],'ylabel',['Temperature anomaly [' char(963) ']'] ,'FontSize',16);

% ssp+his2pro2+集合
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
meanstdall=[stats_SMroot_GDFC(:,end) stats_SMroot_GLDAS(:,end) stats_SMroot_ERA5(:,end) stats_SMroot_Mean(:,end) stats_SMsurf_GDFC(:,end) stats_SMsurf_GLDAS(:,end) stats_SMsurf_ERA5(:,end) stats_SMsurf_Mean(:,end) pxSSP];
% meanstdall=[stats_SMroot_GDFC(:,end) stats_SMroot_GLDAS(:,end) stats_SMroot_ERA5(:,end) stats_SMroot_Mean(:,end) pxSSP];

% clear stats_mod1 px stats_mod1 stats_mod2 pxSSP
% close all
meanstd([73 78 69 71.1 65.5 69.9])%复合加剧
meanstd([25 18.9 28 20.7 16.5 23.4])%降水亏缺
meanstd([1 1.7 2 6.7 6.7 5.3])%热浪型
meanstd([1 1.3 1 1.6 1.3 1.4])%降水亏缺
% Fig.1f 占比误差 【24种模型】
lentext={'Heatwave','Compound','Pre.deficit','Snow/cold','Normal'};
barmeanstd(meanstdall',[colors;0.85 0.85 0.85],lentext,'order', 1)

  xlim([0 5])
yticks([0 10 20 30 40]);
    ylim([0 40])
% barmeanstd([[73 78 69 71.1 65.5 69.9]' [25 18.9 28 20.7 16.5 23.4]' [1 1.7 2 6.7 6.7 5.3]' [1 1.3 1 1.6 1.3 1.4]'])
%不同r的误差很小(±0.5)
stats_CanESM_QM_His=quadrants(deta_gcm{1}{1}{1},PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','CanESM','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
% stats_MIROC6_QM_His=quadrants(deta_SMroot_MIROC6_QM_His{1},PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','MIROC6','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_IPSLCM_QM_His=quadrants(deta_gcm{1}{1}{2},PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','IPSLCM','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
% 未来%SSP126
stats_CanESM_QM_Pro=quadrants(deta_SMroot_CanESM_QM_Pro{2},PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','CanESM Pro QM-based','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_MIROC6_QM_Pro=quadrants(deta_SMroot_MIROC6_QM_Pro{2},PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','MIROC6 Pro QM-based','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);
stats_IPSLCM_QM_Pro=quadrants(deta_SMroot_IPSLCM_QM_Pro{2},PT0,'QuadrantColors',[RGB3;0.85 0.85 0.85],'TitleString','IPSLCM Pro QM-based','xlabel',['Precipitation Anomaly [' char(963) ']' ],'ylabel',['Temperature Anomaly [' char(963) ']' ]);

addpath('D:\Program Files\MATLAB\R2023a\toolbox\ncx\ncx')
%三种色带类型（单色渐变、两端发散、类别）调用方法
% cmap = cbrewer2('seq', 'Blues', 7, 'PCHIP');
% cmap = cbrewer2('div', 'RdBu', 9, 'PCHIP');
% cmap = cbrewer2('qual', 'Set1', 4);
%主导类型【平均+同意地图】

ZD_obs=cellfun(@getZD,[CAT_obs CAT_obssurf],'UniformOutput',false);
for i=1:4
    disp(i)
    zi=cellfun(@getZD,CAT_gcm{i}([1 2]),'UniformOutput',false);
    zi=cellfun(@(x) mean(x, 3),zi,'UniformOutput',false);
    ZD_gcm{i}=cat(3,zi{:});
end
ZD_gcmx=cat(3,ZD_gcm{:});

clear  ZD_gcm CATi1 CATi2
ZDall=cat(3,ZD_obs{:},ZD_gcmx);
ZDall=ZDall(:,:,[2 4 6 8]);
%%  Fig.1e. 投票出来的众数
ZDallmode=myapply(ZDall,3,@(x) mode(x));
globalMap(ZDallmode, latForm, lonForm,'RGB',RGB3,'Projection','eckert3','region','IPCC','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')
%一元色带
globalMapIPCC1(ZDallmode, latForm, lonForm,'region','IPCC','RGB',RGB3,'Math','mode','Projection','eckert3','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')
% Fig.1e.一元色带+显著性
nc=3;
ZDallnum=myapply(ZDall,3,@(x) sum(x == mode(x)));
RGBnc=[cbrewer2('seq', RBG4lei{1}, nc);cbrewer2('seq', RBG4lei{2}, nc);cbrewer2('seq', RBG4lei{3}, nc);cbrewer2('seq', RBG4lei{4}, nc)];
% globalMapIPCC1(ZDallmode, latForm, lonForm,'region','IPCC','RGB',RGBnc,'remeth',"bilinear",'Math','mode','defaultConf',ZDallnum,'defaultsubplot',0,'Projection','pcarree','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','Historical  Flash Drought Types (Multi model voting)','ColorBarLabel','Types [regime]')
[hFig,IPCChatewave,IPCCprecdefict]=globalMapIPCC1tpye(ZDallmode, latForm, lonForm,'region','IPCC','RGB',RGBnc,'remeth',"bilinear",'Math','mode','defaultConf',ZDallnum,'defaultsubplot',0,'Projection','pcarree','shadow',maskpre,'showline',0,'climx',[ 0.5 4.5],'TitleString','','ColorBarLabel','')

%[支持信息 Extended Data Fig.2]绘制降水型历时长，热浪历时短
IPCCname={IPCCRe_meanDuration.Acronym};
[tfhatewave, lochatewave] = ismember(IPCChatewave, IPCCname);
[tfprecdefi, locprecdefi] = ismember(IPCCprecdefict,IPCCname);
lochatewave = lochatewave(lochatewave > 0);
locprecdefi = locprecdefi(locprecdefi > 0);
valuehatewave=[IPCCRe_meanDuration(lochatewave).value];
valueprecdefi =[IPCCRe_meanDuration(locprecdefi).value];
ind1=[2 3 5 6 7 8 9 10 11 12 13 14];%热浪地区索引Fig.1f
heatVSPrep(valuehatewave(ind1),valueprecdefi,IPCCname(lochatewave(ind1)), IPCCname(locprecdefi),12)

%二元映射
globalMap2IPCC(SPISTI_SMroot_Mean(:,:,1),SPISTI_SMroot_Mean(:,:,2), latForm, lonForm,'region','IPCC','RGB',RGB1,'Projection','pcarree','shadow',maskpre,'climx',[0 3],'TitleString','Historical Flash Drought Events (Mean root SM)','ColorBarLabel','Mean duration [pentads·yr^{-1}]')


% see3d(ZDall)
% FIG. 同意地图
% ZDall=ZDall(:,:,[1:4 ]);

point=ZDallnum>=floor(size(ZDall,3)*0.5);
RGB4=cbrewer2('seq', 'gnbu',size(ZDall,3));%每行是一个RGB颜色
globalMap(ZDallnum, latForm, lonForm,'RGB',RGB4,'Projection','eckert3','region','IPCC','shadow',maskpre,'showline',1,'climx',[ 0.5 size(ZDall,3)+0.5],'point',point,'TitleString','Agreement Map (Multi model voting SM)','ColorBarLabel','Number of members')

%% Fig3 Heatwave-driven骤旱事件三个阶段的特征变化【更快发作，更短历时】





% 归因调查了每个网格点每场干旱事件期间降水量、气温和蒸散发量的年际变化，以及三者之间的相关关系（剔除了干旱事件数量小于20的网格点）。
% 1.年气温-蒸发相关系数趋势
% 2.年降水-气温相关关系线性变化


% 直接加载数据
load('干旱事件.mat')
load('指数SSI.mat')
load('指数SPI.mat')
load('指数SEI.mat')
load('指数STI.mat')
load('主导型.mat')
load('掩膜.mat')

