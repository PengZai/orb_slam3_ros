DIR="BotanicGarden/1018_00"

ESITMATED="orbslam3_stereo_inertial_without_loop_clourse_for_1018_00_img10hz600p_kf_traj_insecond.txt"
REFERENCE="gt_poses.tum"

evo_rpe tum $DIR/$ESITMATED $DIR/$REFERENCE  > $DIR/rpe_$ESITMATED.log
evo_ape tum $DIR/$ESITMATED $DIR/$REFERENCE  > $DIR/ape_$ESITMATED.log
evo_ape tum $DIR/$ESITMATED $DIR/$REFERENCE --align --pose_relation trans_part > $DIR/ate_$ESITMATED.log


evo_traj tum $DIR/$ESITMATED --ref=$DIR/$REFERENCE -p --plot_mode=xy --save_plot $DIR/ 
