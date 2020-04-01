import csv
import json
import sys

tsne_fn = sys.argv[1]#'2d_coordinates.csv'
meta_fn = sys.argv[2]#'sample_annotations.csv'

cells = {}
with open(tsne_fn) as f :
    # consume header (sample_name, tsne_1, tsne_2)
    header = next(f).strip().replace('"','').split(',')
    for r in csv.DictReader(f,fieldnames=header) :
        cells[r['sample_name']] = r

annot_cols = (
        'cluster_color',
        'cluster_label',
        'class_color',
        'class_label',
        'subclass_color',
        'subclass_label',
        'region_color',
        'region_label'
    )
with open(meta_fn) as f :
    # consume header
    header = next(f).strip().replace('"','').split(',')
    for r in csv.DictReader(f,fieldnames=header) :
        if r['sample_name'] in cells :
            for k in annot_cols :
                cells[r['sample_name']][k] = r[k].replace('grey','999999').replace('#','')

json.dump(list(cells.values()),sys.stdout)
#sample_name
#cluster_color
#cluster_order
#cluster_label
#class_color
#class_order
#class_label
#subclass_color
#subclass_order
#subclass_label
#full_genotype_color
#full_genotype_order
#full_genotype_label
#donor_sex_color
#donor_sex_order
#donor_sex_label
#region_color
#region_order
#region_label
#cortical_layer_color
#cortical_layer_order
#cortical_layer_label
#cell_type_accession_color
#cell_type_accession_order
#cell_type_accession_label
#cell_type_alias_color
#cell_type_alias_order
#cell_type_alias_label
#cell_type_alt_alias_color
#cell_type_alt_alias_order
#cell_type_alt_alias_label
#cell_type_designation_color
#cell_type_designation_order
#cell_type_designation_label
#external_donor_name_color
#external_donor_name_order
#external_donor_name_label

