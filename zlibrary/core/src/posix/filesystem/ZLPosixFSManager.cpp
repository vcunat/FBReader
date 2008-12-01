/*
 * Copyright (C) 2004-2008 Geometer Plus <contact@geometerplus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#include <sys/stat.h>
#include <unistd.h>

#include <ZLibrary.h>
#include <ZLStringUtil.h>

#include "ZLPosixFSManager.h"
#include "ZLPosixFSDir.h"

ZLFSDir *ZLPosixFSManager::createPlainDirectory(const std::string &path) const {
	return new ZLPosixFSDir(path);
}

bool ZLPosixFSManager::removeFile(const std::string &path) const {
	return unlink(path.c_str()) == 0;
}

int ZLPosixFSManager::findLastFileNameDelimiter(const std::string &path) const {
	int index = findArchiveFileNameDelimiter(path);
	if (index == -1) {
		index = path.rfind(ZLibrary::FileNameDelimiter);
	}
	return index;
}
