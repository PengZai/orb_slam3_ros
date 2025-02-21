DIR="BotanicGarden/1005_07"

ESITMATED_FOLDER="orbslam3_stereo_inertial_with_loop_clourse_for_1005_07_img10hz600p_cam_traj"
REFERENCE="1005_07_GT_output.txt"

evo_rpe tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt $DIR/$REFERENCE  > $DIR/${ESITMATED_FOLDER}/rpe_${ESITMATED_FOLDER}_coordinate_aligned.log
evo_ape tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt $DIR/$REFERENCE  > $DIR/${ESITMATED_FOLDER}/ape_${ESITMATED_FOLDER}_coordinate_aligned.log
evo_ape tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt $DIR/$REFERENCE --align --pose_relation trans_part > $DIR/${ESITMATED_FOLDER}/ate_${ESITMATED_FOLDER}_coordinate_aligned.log


evo_traj tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt --ref=$DIR/$REFERENCE -p --plot_mode=xyz --save_plot $DIR/${ESITMATED_FOLDER}/3d  
evo_traj tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt --ref=$DIR/$REFERENCE -p --plot_mode=xy --save_plot $DIR/${ESITMATED_FOLDER}/2d 
