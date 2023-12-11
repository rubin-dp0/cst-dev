"""An example showing how to use the Rubin Science Platform
API Aspect to perform some simple queries
"""
import os
import pandas as pd

from lsst.rsp import get_tap_service


def hello_dp02():
    os.environ["EXTERNAL_TAP_URL"] = "https://data.lsst.cloud/api/tap"
    service = get_tap_service("tap")
    print(f"TAP service {service.baseurl} instantiated")

    # Execute a simple cone search about a point, retrieve and save the results to file
    query = """
    SELECT objectId, coord_ra, coord_dec, detect_isPrimary, 
    g_cModelFlux, r_cModelFlux, r_extendedness, r_inputCount
    FROM dp02_dc2_catalogs.Object
    WHERE CONTAINS(POINT('ICRS', coord_ra, coord_dec), CIRCLE('ICRS', 62,-36, 0.5)) = 1
    AND detect_isPrimary = 1 AND r_extendedness = 0
    AND scisql_nanojanskyToAbMag(r_cModelFlux) < 18.0
    ORDER by r_cModelFlux DESC LIMIT 5
    """

    # Query and displsy results
    results = service.search(query).to_table().to_pandas()
    print(results)


def hello_dp03():
    os.environ["EXTERNAL_TAP_URL"] = "https://data.lsst.cloud/api/ssotap"
    service = get_tap_service("ssotap")
    print(f"TAP service {service.baseurl} instantiated")

    # Execute a query joining the MPCORB and SSObject tables to return a sample of 10 Objects
    query = """
    SELECT mpc.ssObjectId, mpc.e, mpc.incl, mpc.q, mpc.peri,
    sso.ssObjectId, sso.g_H, sso.r_H, sso.i_H, sso.z_H 
    FROM dp03_catalogs_10yr.MPCORB as mpc 
    JOIN dp03_catalogs_10yr.SSObject as sso 
    ON mpc.ssObjectId = sso.ssObjectId 
    WHERE mpc.ssObjectId < 9223370875126069107 
    AND mpc.ssObjectId > 7331137166374808576 
    AND sso.numObs > 50"""

    # Query and display results
    results = service.search(query, maxrec=5).to_table().to_pandas()
    print(results)


def get_image_cutout():
    os.environ["IMAGE_CUTOUT_URL"] = "https://data.lsst.cloud/api/cutout"
    service = get_tap_service("ssotap")
    print(f"TAP service {service.baseurl} instantiated")


if __name__ == "__main__":
    print("Hello Rubin ... querying the RSP")
    hello_dp02()
    # hello_dp03()
