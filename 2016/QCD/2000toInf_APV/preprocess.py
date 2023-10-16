#!/usr/bin/env python
import os
import sys
import subprocess
import ROOT
from importlib import import_module

from PhysicsTools.NanoAODTools.postprocessing.framework.datamodel import Collection
from PhysicsTools.NanoAODTools.postprocessing.framework.eventloop import Module
from PhysicsTools.NanoAODTools.postprocessing.modules.jme.jetmetHelperRun2 import *
from PhysicsTools.NanoAODTools.postprocessing.modules.jme.jetRecalib import *
from PhysicsTools.NanoAODTools.postprocessing.modules.common.puWeightProducer import *
from PhysicsTools.NanoAODTools.postprocessing.framework.postprocessor import *
from PhysicsTools.NanoAODTools.postprocessing.modules.common.PrefireCorr import *

from PhysicsTools.NanoAODTools.postprocessing.modules.jme.jetmetUncertainties import *
from PhysicsTools.NanoAODTools.postprocessing.modules.jme.fatJetUncertainties import *

# JEC dict
# https://twiki.cern.ch/twiki/bin/viewauth/CMS/JECDataMC#Recommended_for_MC
jecTagsMC = {
    '2016': 'Summer16_07Aug2017_V11_MC',
    '2017': 'Fall17_17Nov2017_V32_MC',
    '2018': 'Autumn18_V19_MC',
    'UL2016_preVFP': 'Summer19UL16APV_V7_MC',
    'UL2016': 'Summer19UL16_V7_MC',
    'UL2017': 'Summer19UL17_V5_MC',
    'UL2018': 'Summer19UL18_V5_MC',
}

jecTagsFastSim = {
    '2016': 'Spring16_25nsFastSimV1_MC',
    '2017': 'Fall17_FastSimV1_MC',
    '2018': 'Autumn18_FastSimV1_MC',
}

# https://twiki.cern.ch/twiki/bin/viewauth/CMS/JECDataMC#Recommended_for_Data
archiveTagsDATA = {
    '2016': 'Summer16_07Aug2017_V11_DATA',
    '2017': 'Fall17_17Nov2017_V32_DATA',
    '2018': 'Autumn18_V19_DATA',
    'UL2016_preVFP': 'Summer19UL16APV_V7_DATA',
    'UL2016': 'Summer19UL16_V7_DATA',
    'UL2017': 'Summer19UL17_V5_DATA',
    'UL2018': 'Summer19UL18_V5_DATA'
}

jecTagsDATA = {
    '2016B': 'Summer16_07Aug2017BCD_V11_DATA',
    '2016C': 'Summer16_07Aug2017BCD_V11_DATA',
    '2016D': 'Summer16_07Aug2017BCD_V11_DATA',
    '2016E': 'Summer16_07Aug2017EF_V11_DATA',
    '2016F': 'Summer16_07Aug2017EF_V11_DATA',
    '2016G': 'Summer16_07Aug2017GH_V11_DATA',
    '2016H': 'Summer16_07Aug2017GH_V11_DATA',
    '2017B': 'Fall17_17Nov2017B_V32_DATA',
    '2017C': 'Fall17_17Nov2017C_V32_DATA',
    '2017D': 'Fall17_17Nov2017DE_V32_DATA',
    '2017E': 'Fall17_17Nov2017DE_V32_DATA',
    '2017F': 'Fall17_17Nov2017F_V32_DATA',
    '2018A': 'Autumn18_RunA_V19_DATA',
    '2018B': 'Autumn18_RunB_V19_DATA',
    '2018C': 'Autumn18_RunC_V19_DATA',
    '2018D': 'Autumn18_RunD_V19_DATA',
    'UL2016_preVFPB': 'Summer19UL16APV_RunBCD_V7_DATA',
    'UL2016_preVFPC': 'Summer19UL16APV_RunBCD_V7_DATA',
    'UL2016_preVFPD': 'Summer19UL16APV_RunBCD_V7_DATA',
    'UL2016_preVFPE': 'Summer19UL16APV_RunEF_V7_DATA',
    'UL2016_preVFPF': 'Summer19UL16APV_RunEF_V7_DATA',
    'UL2016F': 'Summer19UL16_RunFGH_V7_DATA',
    'UL2016G': 'Summer19UL16_RunFGH_V7_DATA',
    'UL2016H': 'Summer19UL16_RunFGH_V7_DATA',
    'UL2017B': 'Summer19UL17_RunB_V5_DATA',
    'UL2017C': 'Summer19UL17_RunC_V5_DATA',
    'UL2017D': 'Summer19UL17_RunD_V5_DATA',
    'UL2017E': 'Summer19UL17_RunE_V5_DATA',
    'UL2017F': 'Summer19UL17_RunF_V5_DATA',
    'UL2018A': 'Summer19UL18_RunA_V5_DATA',
    'UL2018B': 'Summer19UL18_RunB_V5_DATA',
    'UL2018C': 'Summer19UL18_RunC_V5_DATA',
    'UL2018D': 'Summer19UL18_RunD_V5_DATA',
}

# https://twiki.cern.ch/twiki/bin/view/CMS/JetResolution
jerTagsMC = {
    '2016': 'Summer16_25nsV1_MC',
    '2017': 'Fall17_V3_MC',
    '2018': 'Autumn18_V7b_MC',
    'UL2016_preVFP': 'Summer20UL16APV_JRV3_MC',
    'UL2016': 'Summer20UL16_JRV3_MC',
    'UL2017': 'Summer19UL17_JRV2_MC',
    'UL2018': 'Summer19UL18_JRV2_MC',
}

# jet mass resolution: https://twiki.cern.ch/twiki/bin/view/CMS/JetWtagging
#nominal, up, down
jmrValues = {
    '2016': [1.0, 1.2, 0.8],
    '2017': [1.09, 1.14, 1.04],
    # Use 2017 values for 2018 until 2018 are released
    '2018': [1.09, 1.14, 1.04],
    'UL2016_preVFP': [1.00, 1.00, 1.00],  # placeholder
    'UL2016': [1.00, 1.00, 1.00],  # placeholder
    'UL2017': [1.00, 1.00, 1.00],  # placeholder
    'UL2018': [1.00, 1.00, 1.00],  # placeholder
}

# jet mass scale
# W-tagging PUPPI softdrop JMS values: https://twiki.cern.ch/twiki/bin/view/CMS/JetWtagging
# 2016 values
jmsValues = {
    '2016': [1.00, 0.9906, 1.0094],  # nominal, down, up
    '2017': [0.982, 0.978, 0.986],
    # Use 2017 values for 2018 until 2018 are released
    '2018': [0.982, 0.978, 0.986],
    'UL2016_preVFP': [1.000, 1.000, 1.000],  # placeholder
    'UL2016': [1.000, 1.000, 1.000],  # placeholder
    'UL2017': [1.000, 1.000, 1.000],  # placeholder
    'UL2018': [1.000, 1.000, 1.000],  # placeholder
}   
def GetJSON(year):
    path = "/cms/xaastorage/UL_JSON_FILES/"
    if year == "UL2016" or year == "UL2016_preVFP": return path+"Cert_271036-284044_13TeV_Legacy2016_Collisions16_JSON.txt"
    if year == "UL2017": return path+"Cert_294927-306462_13TeV_UL2017_Collisions17_GoldenJSON.txt"
    if year == "UL2018": return path+"Cert_314472-325175_13TeV_Legacy2018_Collisions18_JSON.txt"

def preprocess(Inputs, OutputFolder, Year, Run, Triggers, haddOut):
    JSON = None
    useModules = [PrefCorr()]
    print(Run)
    if Run == "MC":
        jmeCorrectionsAK8 = createJMECorrector(True, Year, Run, "All", "AK8PFPuppi")
        useModules.append(jmeCorrectionsAK8())
        if Year == "UL2016" or Year == "UL2016_preVFP":
            useModules.append(puWeight_2016())
        if Year == "UL2017":
            useModules.append(puWeight_2017())
        if Year == "UL2018":
            useModules.append(puWeight_2018())
    else:
        jmeCorrectionsAK8 = createJMECorrector(False, Year, Run, "Total", "AK8PFPuppi")
        useModules.append(jmeCorrectionsAK8())
        JSON = GetJSON(Year)


    preproc_cuts = "PV_npvsGood>0"


#    with open(Triggers) as triggers:
#        ntrig = 0
#        for trigger in triggers:
#            if ntrig > 0: preproc_cuts += "||"
#            preproc_cuts += trigger.rstrip()+">0"
#            ntrig+=1
#    preproc_cuts += ")"
    p = PostProcessor(OutputFolder, [Inputs], preproc_cuts, modules=useModules, provenance=False, outputbranchsel="keepfile.txt", jsonInput=JSON, fwkJobReport=True, haddFileName=haddOut)
    p.run()

preprocess(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6])
