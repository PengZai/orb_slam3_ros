DIR="BotanicGarden/1018_00"

ESITMATED_FOLDER="orbslam3_stereo_inertial_without_loop_clourse_for_1018_00_img10hz600p_kf_traj"
REFERENCE="1018_00_GT_output.txt"

evo_rpe tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt $DIR/$REFERENCE  > $DIR/${ESITMATED_FOLDER}/rpe_${ESITMATED_FOLDER}_coordinate_aligned.log
evo_ape tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt $DIR/$REFERENCE  > $DIR/${ESITMATED_FOLDER}/ape_${ESITMATED_FOLDER}_coordinate_aligned.log
evo_ape tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt $DIR/$REFERENCE --align --pose_relation trans_part > $DIR/${ESITMATED_FOLDER}/ate_${ESITMATED_FOLDER}_coordinate_aligned.log


evo_traj tum $DIR/${ESITMATED_FOLDER}/${ESITMATED_FOLDER}_coordinate_aligned.txt --ref=$DIR/$REFERENCE -p --plot_mode=xyz --save_plot $DIR/${ESITMATED_FOLDER}/ 
