function metadata = PCDSPECTRAReleaseMetadata()
%PCDSPECTRARELEASEMETADATA Public add-on metadata.
%
% This file is read by packagePCDSPECTRA. Leave ToolboxImageFile empty until
% a release icon is available, or set it to a path relative to the toolbox
% root.

metadata = struct();
metadata.AuthorName = "Shanli Ding";
metadata.AuthorEmail = "sding2@mdanderson.org";
metadata.AuthorCompany = "The University of Texas MD Anderson Cancer Center";
metadata.CopyrightHolder = "Ke Li Lab";
metadata.CopyrightYear = 2026;
metadata.RequiredNotice = ...
    "Required Notice: Copyright © 2026 Ke Li Lab";
metadata.ToolboxImageFile = "icons/PCD-SPECTRA_icon.png";
end
