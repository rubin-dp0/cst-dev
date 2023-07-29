#.. list-table:: Image data available for DP0.3.
#   :widths: 100 100 390
#   :header-rows: 1

#   * - Butler DatasetType
#     - Minimum ``dataId``
#     - Description
#   * - ``calexp``
#     - visit, detector
#     - Processed visit image with the background subtracted.
#   * - ``calexpBackground``
#     - visit, detector
#     - The background subtracted from the ``calexp``.
#   * - ``deepCoadd``
#     - tract, patch, band
#     - The deep stack of the ``calexps``.
#   * - ``deepCoadd_calexp``
#     - tract, patch, band
#     - The deep stack of the ``calexps``, with a final small background subtracted.
#   * - ``deepCoadd_calexp_background``
#     - tract, patch, band
#     - The background subtracted from ``deepCoadd_calexp``.
#   * - ``goodSeeingCoadd``
#     - tract, patch, band
#     - The deep stack of the ``calexps`` with the top one-third best seeing visits.
#   * - ``goodSeeingDiff_templateExp``
#     - visit, detector
#     - The template image used for difference image analysis.
#   * - ``goodSeeingDiff_differenceExp``
#     - visit, detector
#     - The difference image resulting from difference image analysis.
#
#|

import yaml

def print_one_table(d):

    print('.. list-table:: ' + d['name'] + ' DP0.3 table.')
    print('   :widths: 100 200 390')
    print('   :header-rows: 1')

    print('')

    print('   * - column name')
    print('     - data type')
    print('     - description')
    for c in d['columns']:
        print('   * - ' + c['name'].strip())
        print('     - ' + c['datatype'].strip())
        if 'description' in c.keys():
            print('     - ' + c['description'].strip())
        else:
            print('     - ')
        #print(c['name'], ' ', c['datatype'], ' ', c['description'])

    print('')
    print('|')


with open('dp03.yaml', 'r') as file:
    yaml_data = yaml.load(file, Loader=yaml.FullLoader)

for i in range(len(yaml_data['tables'])):
    d = yaml_data['tables'][i]
    print_one_table(d)

for i in range(len(yaml_data['tables'])):
    d = yaml_data['tables'][i]
    print(d['name'], ' ', len(d['columns']))
