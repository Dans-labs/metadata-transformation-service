import logging
import os

from fastapi import Query, APIRouter

from src.mts.commons import settings, data, project_details

router = APIRouter()


@router.get("/saved-xsl-list", description="List of saved xsl.", summary="Retrieve saved XSLT files")
def get_saved_xslt_list(
    xslt_name: str | None = Query(
        default=None,
        description="if not provide, all saved list will be given.",
        max_length=100,
    ),
):
    """
    Return the content of one or all saved XSLT stylesheets.

    When `xslt_name` is provided, the response contains only that stylesheet's
    source. When omitted, the response is a dictionary mapping every saved
    `.xsl` filename to its content. Only files ending in `.xsl` are included.
    """
    xslt_list = {}
    logging.debug(f"xslt_name: {xslt_name}")
    logging.debug(f"settings.SAVED_XSLT_DIR: {settings.SAVED_XSLT_DIR}")
    print(f"settings.SAVED_XSLT_DIR: {settings.SAVED_XSLT_DIR}")
    print(f"xslt_name: {xslt_name}")
    logging.debug(f"data.keys(): {data.keys()}")
    print(f"data.keys(): {data.keys()}")
    if xslt_name:
        if xslt_name in data.keys():
            for root, _, files in os.walk(settings.SAVED_XSLT_DIR):
                for filename in files:
                    if filename == xslt_name:
                        logging.debug(filename)
                        with open(os.path.join(root, filename)) as s:
                            xslt_list[filename] = s.read()
                        break

    else:
        logging.debug(f"else")
        print(f"else")
        logging.debug(
            f"os.listdir(settings.SAVED_XSLT_DIR): {os.listdir(settings.SAVED_XSLT_DIR)}"
        )
        print(
            f"os.listdir(settings.SAVED_XSLT_DIR): {os.listdir(settings.SAVED_XSLT_DIR)}"
        )
        for root, _, files in os.walk(settings.SAVED_XSLT_DIR):
            for filename in files:
                if filename.endswith(".xsl"):
                    logging.debug(filename)
                    with open(os.path.join(root, filename)) as s:
                        xslt_list[filename] = s.read()
    return xslt_list


@router.get("/saved-xsl-list-only", description="List (only) of saved xsl.", summary="List XSLT filenames")
def get_saved_xslt_list():
    """
    Return a sorted list of saved XSLT stylesheet filenames.

    Returns only the names (not the content) of all `.xsl` files that have
    been saved in the configured XSLT directory. Useful for enumerating
    available transformations without loading their full content.
    """
    xslt_list = [k for k in data.keys() if k.endswith(".xsl")]
    # for filename in os.listdir(settings.SAVED_XSLT_DIR):
    #     if filename.endswith(".xsl"):
    #         logging.debug(filename)  # logging.debuging file name of desired extension
    #         f = os.path.join(settings.SAVED_XSLT_DIR, filename)
    #         xslt_list.append(filename)
    sorted_list = sorted(xslt_list)

    return sorted_list


@router.get("/info", summary="Service information")
def info():
    """
    Return general information about the Metadata Transformation Service (MTS).

    Provides the service title, version and other metadata as defined in the
    project configuration. Useful for health dashboards and service discovery.
    """
    logging.info("info")
    return project_details
