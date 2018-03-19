'''current test sequence'''
INPUT_SEQUENCE = 'KMAGSIVISKEVRVPVSTSQFDYLVSRIGDQFHSSDMWIKDEVYLPMEEGGMSFISTESLNSSGLSIFLATVMRARAASQAEESFPLYENVWNQLVEKLRQDARLGVSGNTSLEHHHHHH'

'''directory to store all target files'''
#TARGET_DIR = "targets/"
TARGET_DIR = ""

'''name for files'''
TARGET_NAME = "T0869"

'''number of simulated annealing simulations to run'''
NUMBER_SIMULATIONS = 30

import os
import subprocess
import random
import math
import copy
import shutil

def pdb_save_name(pdb_number):
    return TARGET_DIR+TARGET_NAME + "sequence%d" % (pdb_number) +".pdb"
    
def replaceModel(pdb_number):
    
    op = subprocess.check_output("perl fragment2torsion.pl T0869.fragments T0869.random T0869.torsion T0869.out", shell=True)
    op = subprocess.check_output("perl Angle2pdb.pl T0869-new.out  T0869.pdb  /tools/", shell=True)
    src = ""
    drf = pdb_save_name(pdb_number)
    shutil.copy(src,drf)

def PDBScore(pdb_number):

    PDB_OUT_NAME = pdb_save_name(pdb_number);

    score = -1
    
    while score < 0:
      dfire_output = subprocess.check_output("./dDFIRE " + PDB_OUT_NAME, shell=True)
      dfire_output_split = dfire_output.split(":")
      dfire_output_split_nums = dfire_output_split[1].split(" ")
      score = float(dfire_output_split_nums[1])

    print("pdb:", pdb_number, "score:", float(score))

    return score

def temperature(k):
  return -5000/(1 + math.exp(-k/200)) + 5000


def main():

    #cleanup
    if not os.path.exists(TARGET_DIR+TARGET_NAME):
        print("Making temp directory")
        os.mkdir(TARGET_DIR+TARGET_NAME)
    else:
        print("Clearing temp directory")
        for root,dirs,files in os.walk(TARGET_DIR+TARGET_NAME,topdown=False):
            for name in dirs:
                shutil.rmtree(os.path.join(root,name))

    #build initial random model, maybe not useful here
    #InitiazationModel();
    
    best_dfire_score = 1e6 #best is lowest

    old_model_number = 0
    num_pdbs = 1

    best_model = old_model_number
    best_score = best_dfire_score

    for k in range(1,NUMBER_SIMULATIONS+1):
        # Grab temperature
        T = temperature(k)

        # Create neighbor model and save in TARGET_DIR/TARGET_NAME/, and the model's
        # name is "sequence%d" % (pdb_number) +".pdb"
        # ex. targets/T0869/sequence1.pdb
        replaceModel(k)

        # Calculate score. Lower is better
        neighbor_score = PDBScore(k)
              
        # Calculate score difference
        score_diff = neighbor_score - best_score
        # If score_diff is above 0, chance it
        if score_diff > 0:
            score_diff = score_diff if score_diff < 5*T else 5*T
            # Grab the probability of accepting a bad neighbor
            prob_to_accept = math.exp(-100*score_diff/T)
            print("probability to accept:", prob_to_accept)
            # Reject if roll is above probability
            if prob_to_accept < random.random():
                continue
            print("accepted neighbor anyway")
        best_model = k
        best_score = neighbor_score

        num_pdbs += 1

    print("best model found:", best_model, "score:", best_score)

if __name__ == "__main__":
    main()

