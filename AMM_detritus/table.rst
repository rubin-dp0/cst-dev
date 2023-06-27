.. list-table:: Image data available for DP0.3.
   :widths: 100 200 390
   :header-rows: 1

   * - column name
     - data type
     - description
   * - ssObjectId
     - long
     - Unique identifier.
   * - discoverySubmissionDate
     - double
     - The date the LSST first linked and submitted the discovery observations to the MPC. May be NULL if not an LSST discovery. The date format will follow general LSST conventions (MJD TAI, at the moment).
   * - firstObservationDate
     - double
     - The time of the first LSST observation of this object (could be precovered)
   * - arc
     - float
     - Arc of LSST observations
   * - numObs
     - int
     - Number of LSST observations of this object
   * - MOID
     - float
     - Minimum orbit intersection distance to Earth
   * - MOIDTrueAnomaly
     - float
     - True anomaly of the MOID point
   * - MOIDEclipticLongitude
     - float
     - Ecliptic longitude of the MOID point
   * - MOIDDeltaV
     - float
     - DeltaV at the MOID point
   * - uH
     - float
     - Best fit absolute magnitude (u band)
   * - uG12
     - float
     - Best fit G12 slope parameter (u band)
   * - uHErr
     - float
     - Uncertainty of H (u band)
   * - uG12Err
     - float
     - Uncertainty of G12 (u band)
   * - uH_uG12_Cov
     - float
     - H-G12 covariance (u band)
   * - uChi2
     - float
     - Chi^2 statistic of the phase curve fit (u band)
   * - uNdata
     - int
     - The number of data points used to fit the phase curve (u band)
   * - gH
     - float
     - Best fit absolute magnitude (g band)
   * - gG12
     - float
     - Best fit G12 slope parameter (g band)
   * - gHErr
     - float
     - Uncertainty of H (g band)
   * - gG12Err
     - float
     - Uncertainty of G12 (g band)
   * - gH_gG12_Cov
     - float
     - H-G12 covariance (g band)
   * - gChi2
     - float
     - Chi^2 statistic of the phase curve fit (g band)
   * - gNdata
     - int
     - The number of data points used to fit the phase curve (g band)
   * - rH
     - float
     - Best fit absolute magnitude (r band)
   * - rG12
     - float
     - Best fit G12 slope parameter (r band)
   * - rHErr
     - float
     - Uncertainty of H (r band)
   * - rG12Err
     - float
     - Uncertainty of G12 (r band)
   * - rH_rG12_Cov
     - float
     - H-G12 covariance (r band)
   * - rChi2
     - float
     - Chi^2 statistic of the phase curve fit (r band)
   * - rNdata
     - int
     - The number of data points used to fit the phase curve (r band)
   * - iH
     - float
     - Best fit absolute magnitude (i band)
   * - iG12
     - float
     - Best fit G12 slope parameter (i band)
   * - iHErr
     - float
     - Uncertainty of H (i band)
   * - iG12Err
     - float
     - Uncertainty of G12 (i band)
   * - iH_iG12_Cov
     - float
     - H-G12 covariance (i band)
   * - iChi2
     - float
     - Chi^2 statistic of the phase curve fit (i band)
   * - iNdata
     - int
     - The number of data points used to fit the phase curve (i band)
   * - zH
     - float
     - Best fit absolute magnitude (z band)
   * - zG12
     - float
     - Best fit G12 slope parameter (z band)
   * - zHErr
     - float
     - Uncertainty of H (z band)
   * - zG12Err
     - float
     - Uncertainty of G12 (z band)
   * - zH_zG12_Cov
     - float
     - H-G12 covariance (z band)
   * - zChi2
     - float
     - Chi^2 statistic of the phase curve fit (z band)
   * - zNdata
     - int
     - The number of data points used to fit the phase curve (z band)
   * - yH
     - float
     - Best fit absolute magnitude (y band)
   * - yG12
     - float
     - Best fit G12 slope parameter (y band)
   * - yHErr
     - float
     - Uncertainty of H (y band)
   * - yG12Err
     - float
     - Uncertainty of G12 (y band)
   * - yH_yG12_Cov
     - float
     - H-G12 covariance (y band)
   * - yChi2
     - float
     - Chi^2 statistic of the phase curve fit (y band)
   * - yNdata
     - int
     - The number of data points used to fit the phase curve (y band)
   * - maxExtendedness
     - float
     - maximum `extendedness` value from the DIASource
   * - minExtendedness
     - float
     - minimum `extendedness` value from the DIASource
   * - medianExtendedness
     - float
     - median `extendedness` value from the DIASource
   * - flags
     - long
     - Flags, bitwise OR tbd.
